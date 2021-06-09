#' A WebSocket template
#' @description
#' This class manages WebSocket connections to polygon.io clusters.
#' @section Public Methods:
#' \describe{
#'   \item{\code{close}}{close WebSocket connection.}
#'   \item{\code{connect_to_cluster}}{connect to a polygon WebSocket cluster.}
#'   \item{\code{authenticate}}{Authenticate connection.}
#'   \item{\code{subscribe}}{Subscribe to stream.}
#'   \item{\code{unsubscribe}}{Unsubscribe from a stream.}
#' }
#' @return A WebSocket template.
#' @export
WebSocket <- R6::R6Class(
  classname  = "WebSocket",
  cloneable  = FALSE,
  lock_class = TRUE,

  public = list(
    ws = NULL,
    cluster = NULL,

    initialize = function(cluster){
      self$cluster <- cluster
      self$ws <- self$connect_to_cluster(cluster)

      # Events
      self$ws$onOpen(function(event) {
        cat("Connection opened\n")
      })
      self$ws$onMessage(function(event) {
        cat(event$data, "\n")
      })
      self$ws$onClose(function(event) {
        cat("Client disconnected with code ", event$code,
            " and reason ", event$reason, "\n", sep = "")
      })
      self$ws$onError(function(event) {
        cat("Client failed to connect to polygon.io: ", event$message, "\n")
      })

      # Authenticate & connect
      self$ws$connect()
      p <- promises::promise(private$promise)
      private$run_child_loop_until_resolved(p)
      self$authenticate()
    },

    # close database connection
    close = function() {
      self$ws$close()
    },

    # connect to a polygon cluster of interest
    connect_to_cluster = function(cluster){
      url <- glue::glue("wss://socket.polygon.io/{cluster}")
      ws <- websocket::WebSocket$new(url = url, autoConnect = FALSE)
    },

    # Authenticate connection
    authenticate = function() {
      token <- polygon_auth()
      msg <- glue::glue('{{"action":"auth","params":"{token}"}}')
      self$ws$send(msg)
    },

    # Subscribe to stream
    subscribe = function(tickers) {
      if(!is.character(tickers)) stop("tickers is not a character vector")
      if(length(tickers) > 1) tickers <- glue::glue_collapse(tickers, sep = ",")
      msg <- glue::glue('{{"action":"subscribe","params":"{tickers}"}}')
      self$ws$send(msg)
    },

    # Unsubscribe from stream
    unsubscribe = function(tickers) {
      if(!is.character(tickers)) stop("tickers is not a character vector")
      if(length(tickers) > 1) tickers <- glue::glue_collapse(tickers, sep = ",")

      msg <- glue::glue('{{"action":"unsubscribe","params":"{tickers}"}}')
      self$ws$send(msg)
    },

    finalize = function() {
      self$ws$close()
    }
  ),

  private = list(
    # Allow up to 10 seconds to connect to browser.
    promise = function(resolve, reject) {
      self$ws$onOpen(resolve)
      later::later(function() {
        promises::promise_reject(
          "Chromote: timed out waiting for WebSocket connection to browser."
        )
      }, 10)
    },

    run_child_loop_until_resolved = function(p) {
      # Chain another promise that sets a flag when p is resolved.
      p_is_resolved <- FALSE
      p <- promises::then(p, function(value) p_is_resolved <<- TRUE)

      err <- NULL
      promises::catch(p, function(e) err <<- e)

      while (!p_is_resolved && is.null(err) && !later::loop_empty()){
        later::run_now()
      }
      if (!is.null(err)) stop(err)
    }
  )
)
