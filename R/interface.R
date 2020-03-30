#' The fully-rooted local path to a file.
#' @param file_id A list identifying the file.
#' @param config A configuration from \link{data_configuration}.
#' @return A fully-rooted path.
#' @export
local_path <- function(file_id, config) {
  fs::path(config$LOCALDATA, project_path(file_id))
}


#' Save information about a directory or data file.
#'
#' Some well-known properties:
#'
#' \itemize{
#'   \item title Something you would call this data.
#'   \item download_date When the file was
#'   \item creator Person or organization that made the file.
#'   \item format Describe the data format.
#'   \item source_repository The git repository of code that made the data.
#'   \item source_version Version number of the source code.
#'   \item source_branch Branch of the code that made the data.
#'   \item description A free text description of what's in the file.
#'   \item creation_date When the file was created.
#' }
#'
#' @param path The path to the directory or file.
#' @param properties A list of information about that path.
#' @export
document_path <- function(path, properties) {

}


#' Ensure files are available locally.
#'
#' @param ramp_identifiers A list of RAMP IDs.
#' @export
ensure_present <- function(ramp_identifiers) {
  missing_identifiers <- list()
  for (find_entry in ramp_identifiers) {
    if (!is.null(find_entry)) {
      actual <- fs::path(project_base_path(), project_path(find_entry), find_entry$path)
      if (!file.exists(actual)) {
        missing_identifiers[length(missing_identifiers) + 1] <- find_entry
      }  # If it's there, the job is done.
    }  # Null entries happen if you assign to a later integer.
  }

  if (length(missing) > 0) {
    ssh_session <- ssh::ssh_connect(host)
    for (transfer_entry in missing_identifiers) {

    }
    ssh::ssh_disconnect(ssh_session)
  }
}


#' Ensure a set of local files are on the server.
#'
#' Not implemented.
#'
#' @param ramp_identifiers A list of RAMP IDs.
#' @export
ensure_on_server <- function(ramp_identifiers) {

}
