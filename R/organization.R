#' Formats a base path for a file.
#'
#' This function reflects how we want to organize files.
#' It returns a path relative to whatever is the
#' data root.
#'
#' @param stage One of (input, working, output). Must not be NULL.
#' @param location If this is associated with a location. Can be NULL.
#' @param project The Github project or R project name, without a slash.
#'   Can be NULL.
#' @param user The username for the person's working directory.
#' @param rproject The Rstudio project name.
#' @return a path to use as a base path for this dataset.
#' @export
ramp_path <- function(stage, location, project, user, rproject, path = NULL) {
  if (stage == "input") {
    if (!is.null(location)) {
      base <- fs::path("countries", location)
    } else if (!is.null(project)) {
      base <- fs::path("projects", project)
    } else if (!is.null(rproject)) {
      base <- fs::path("rprojects", rproject)
    } else {
      stop("An input file needs a location, project, or rproject.")
    }
    final <- base
  } else if (stage == "working") {
    if (is.null(user)) {
      stop("All working data is stored by username, so supply a user when stage=working.")
    }
    base <- fs::path("users", user)
    if (!is.null(project)) {
      final <- fs::path(base, project)
    } else if (!is.null(rproject)) {
      final <- fs::path(base, rproject)
    } else {
      final <- base
    }
  } else if (stage == "output") {
    if (!is.null(project)) {
      base <- fs::path("projects", project)
    } else if (!is.null(rproject)) {
      base <- fs::path("rprojects", rproject)
    } else {
      stop("An output file needs a project, or rproject.")
    }
    final <- base
  } else {
    stop(paste("stage should be one of (working, input, output) but is", stage))
  }
  if (!is.null(path)) {
    final <- fs::path(final, path)
  }
  final
}




#' Creates a path relative to the project root, following
#'
#' @param file_id A list with keys (stage, location, project, user, rproject).
#'   If user is missing, the effective user is supplied.
#'   Only stage is required.
#' @return a path to use as a base path for this dataset.
#' @seealso \link{ramp_path}
#' @export
project_path <- function(file_id) {
  keys <- names(file_id)
  if (!"user" %in% keys | is.null(file_id$user)) {
    user <- Sys.info()[["effective_user"]]
  } else {
    user <- file_id$user
  }
  complete <- list(
    user = user, stage = NULL, location = NULL, project = NULL, rproject = NULL, path = NULL
    )
  for (name in names(file_id)) {
    complete[[name]] <- file_id[[name]]
  }
  do.call(ramp_path, complete)
}
