#' Formats a base path for a file.
#'
#' This function reflects how we want to organize files.
#' It returns a path relative to whatever is the
#' data root.
#'
#' @param country If this is associated with a country. Can be NULL.
#' @param project The Github project or R project name, without a slash.
#'   Can be NULL.
#' @param stage One of (source, user, prod). Must not be NULL.
#' @return a path to use as a base path for this dataset.
ramp_path <- function(country, project, stage) {
  user <- Sys.info()[["effective_user"]]
  base <- ifelse(!is.null(country), country, vector(mode = "character", length = 0L))
  usage <- c(base, stage)
  if (is.null(project)) {
    with_project <- usage
  } else {
    with_project <- c(usage, project)
  }
  if (stage %in% c("user")) {
    full <- c(with_project, user)
  } else {
    full <- with_project
  }
  do.call(fs::path, as.list(full))
}


#' Creates a path relative to the project root, following
#'
#' @param country If this is associated with a country. Can be NULL.
#' @param project The Github project or R project name, without a slash.
#'   Can be NULL.
#' @param stage One of (source, user, prod). Must not be NULL.
#' @return a path to use as a base path for this dataset.
project_path <- function(country, project, stage) {
  base <- ifelse(!is.null(country), country, vector(mode = "character", length = 0L))
  usage <- c(base, stage)
  do.call(fs::path, as.list(usage))
}
