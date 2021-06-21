#' Isolation forest recipe step
#'
#' @param recipe The recipe object
#' @param ... Additional arguments
#' @param role Role of the transformed output
#' @param trained Has the model been trained (TRUE/FALSE)
#' @param iso_mod Prepped/trained isolation forest model object.
#' @param sample_size (solitude) (positive integer, default = 256) Number of observations in the dataset to used to build a tree in the forest
#' @param num_trees (solitude) num_trees: (positive integer, default = 100) Number of trees to be built in the forest
#' @param max_depth (solitude) max_depth: (positive number, default: ceiling(log2(sample_size))) See max.depth argument in ranger
#' @param options additional default arguments to the solitude isolation forest API.
#' @param skip Whether to skip the baking step for new data.
#' @param id Name of the step
#'
#' @return
#' @export
#'
#' @examples
#'
#'library(dplyr)
#'library(tidymodels)
#'
#'
#'splits <- initial_split(mtcars)
#'train <- training(splits)
#'test <- testing(splits)
#'resamples <- bootstraps(train, times = 5)
#'
#'rec_obj <-
#'recipe(mpg ~ ., data = mtcars) %>%
#'    step_dummy(all_nominal_predictors()) %>%
#'    step_isofor(all_predictors(), sample_size = tune(), max_depth = tune())
#'
#'lm_mod <- linear_reg() %>%
#'   set_engine("lm")
#'
#'wf_linear <- workflow() %>%
#'   add_recipe(rec_obj) %>%
#'   add_model(lm_mod)
#'
#'iso_param <- wf_linear %>%
#'   parameters() %>%
#'   update(sample_size = sample_size(c(1, 24)))
#'
#'tuned_mod <- wf_linear %>%
#'   tune_grid(resamples = resamples, param_info = iso_param)

step_isofor <- function(
  recipe,
  ...,
  role = NA,
  trained = FALSE,
  iso_mod = NULL,
  sample_size = 256,
  num_trees = 100,
  max_depth = 10,
  options = list(nproc = 1, replace = FALSE, seed = 101, respect_unordered_factors = "partition"),
  skip = FALSE,
  id = rand_id("isofor")
) {

  ## The variable selectors are not immediately evaluated by using
  ##  the `quos()` function in `rlang`. `ellipse_check()` captures
  ##  the values and also checks to make sure that they are not empty.
  terms <- ellipse_check(...)

  add_step(
    recipe,
    step_isofor_new(
      terms = terms,
      trained = trained,
      role = role,
      iso_mod = iso_mod,
      sample_size = sample_size,
      num_trees = num_trees,
      max_depth = max_depth,
      options = options,
      skip = skip,
      id = id
    )
  )
}

step_isofor_new <-
  function(terms, trained, role, iso_mod, sample_size, num_trees, max_depth, options, skip, id) {
    step(
      subclass = "isofor",
      terms = terms,
      trained = trained,
      role = role,
      iso_mod = iso_mod,
      sample_size = sample_size,
      num_trees = num_trees,
      max_depth = max_depth,
      options = options,
      skip = skip,
      id = id
    )
  }

#' @export
prep.step_isofor <- function(x, training, info = NULL, ...) {

  col_names <- terms_select(terms = x$terms, info = info)

  iso_mod <- isolationForest$new(sample_size = x$sample_size, num_trees = x$num_trees, max_depth = x$max_depth,
                                 nproc = x$options$nproc, replace = x$options$replace, seed = x$options$seed,
                                 respect_unordered_factors = x$options$respect_unordered_factors)

  iso_mod$fit(training[, col_names])

  step_isofor_new(
    terms = x$terms,
    role = x$role,
    trained = TRUE,
    iso_mod = iso_mod,
    sample_size = x$sample_size,
    num_trees = x$num_trees,
    max_depth = x$max_depth,
    options = x$options,
    skip = x$skip,
    id = x$id
  )
}

#' @export
bake.step_isofor <- function(object, new_data, ...) {

  iso_mod <- object$iso_mod

  new_data$if_score <- iso_mod$predict(new_data)$anomaly_score

  ## Always convert to tibbles on the way out
  tibble::as_tibble(new_data)
}

#' @rdname required_pkgs.step_isofor
#' @export
required_pkgs.step_isofor <- function(x, ...) {
  c("anomalyrecipes")
}
