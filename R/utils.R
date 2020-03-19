#' Check response status
#'
#' Verifies if response status is correct.
#' If not it stops execution with message.
#'
#' @param resp httr response
#' @param expected_code numeric with expected code e.g. 201
#' @param error_message character with error message
#'
#' @importFrom httr status_code
.check_response_status <- function(resp, expected_code,
                                   error_message="Request failed"){
  # compares response status with expeced_code and returns error_message if not equal
  if (status_code(resp) != expected_code) {
    stop(
      sprintf(
        paste(error_message, "[%s]\n"),
        status_code(resp)
      ),
      call. = FALSE
    )
  }
}
