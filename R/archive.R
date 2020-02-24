

#' Unzip a 7zip file.
#'
#' There is a Github project called archive
#' that would do this, too. This command is on Ubuntu but may
#' not be elsewhere.
#'
#' @param archive Path to the file in 7z format.
#' @param where Directory into which to unzip the archive.
#'     This command changes the working directory to `where`
#'     in order to unzip.
#' @export
un7zip <- function(archive, where) {
  archive <- normalizePath(archive)
  current_path <- setwd(where)
  system(paste("7zr x", archive, sep = " "))
  setwd(current_path)
}
