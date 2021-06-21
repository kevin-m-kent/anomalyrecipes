#' Custom tuning functions for the package.
#'
#' @param A recipe step object
#' @param ... Not used
#'
#' @return A tibble

#' @export
tree_depth <- function(range = c(1L, 15L), trans = NULL) {
  new_quant_param(
    type = "integer",
    range = range,
    inclusive = c(TRUE, TRUE),
    trans = trans,
    label = c(sub_classes = "Isolation Forest Tree Depth"),
    finalize = NULL
  )
}

#' @export
sample_size <- function(range = c(unknown(), unknown()), trans = NULL) {
  new_quant_param(
    type = "integer",
    range = range,
    inclusive = c(TRUE, TRUE),
    trans = trans,
    label = c(sub_classes = "Isolation Forest Tree Depth"),
    finalize = NULL
  )
}

#' @rdname tunable.step_isofor
#' @export
tunable.step_isofor <- function (x, ...) {
  tibble::tibble(
    name = c("sample_size", "max_depth"),
    call_info = list(list(pkg = "anomalyrecipes", fun = "sample_size"),
                     list(pkg = "anomalyrecipes", fun = "tree_depth")),
    source = "recipe",
    component = "step_isofor",
    component_id = x$id
  )
}
