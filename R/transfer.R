utils::globalVariables("data_config", package = "rampdata")

#' Reads configuration file on where to download data.
#'
#' It stores that configuration in `data_config`
#' at the global level.
#'
#' If you want to make the config file, then create
#' a file called `$HOME/.config/MASH/data.ini` and put
#' the following in it:
#'
#' @return A list of configuration parameters.
#'
#' @example
#' [Default]
#' SCPHOST = computer-name.ihme.uw.edu
#' SCPHOSTBASE = /path/to/data/directory
#'
#' @export
data_configuration <- function() {
  home <- list(
    xdg = Sys.getenv("XDG_CONFIG_HOME"),
    env = fs::path(Sys.getenv("HOME"), ".config"),
    default = fs::path("", "home", Sys.info()[["effective_user"]])
  )

  for (directory in home) {
    ini_path <- fs::path(directory, "MASH", "data.ini")
    if (file.exists(ini_path)) {
      cfg <- configr::read.config(ini_path)
      if (is.list(cfg)) {
        data_config <<- cfg$Default
        return(data_config)
      }
    }
  }
  FALSE
}


#' Use scp to retrieve data.
#'
#' Only if you have ssh credentials set up.
#' This is used for data that isn't yet public.
#' Equivalent to: ssh ihme.uw.edu:/path/to/file local_file.dat
#'
#' You have to call `data_configuration()` before you call this.
#'
#' @param session An ssh session.
#' @param filename The path of the file within the repository.
#' @param local_directory Where to put that file on the local machine.
#' @export
get_from_ihme <- function(session, filename, local_directory = "inst/extdata") {
  source <- fs::path(data_config$SCPHOSTBASE, filename)
  target <- fs::path(local_directory, fs::path_dir(filename))
  ssh::ssh_download(session, target, to = target)
}


#' Use scp to send data.
#'
#' @param session An ssh session.
#' @param filename The path of the file within the repository.
#' @param local_directory Where to put that file on the local machine.
#' @export
send_to_ihme <- function(session, filename, local_directory = "inst/extdata") {
  source <- fs::path(local_directory, filename)
  target <- fs::path(data_config$SCPHOSTBASE, fs::path_dir(filename))
  ssh::ssh_upload(session, source, to = target)
}


#' Retrieve worldpop data.
#'
#' Worldpop returns several GeoTIFFs in WGS 84.
#' GNQ = Equatorial Guinea
#' 10 or 15 is 2010 or 2015 data.
#' adjv2 or v2 is whether it was adjusted to match WHO.
#' So use GNQ15v2.tif.
#' @param local directory Where to put that file on the local machine.
#' @param overwrite Whether to overwrite an existing file by the same name.
#' @export
download_worldpop <- function(local_directory = "inst/extdata", overwrite = FALSE) {
  local_file <- fs::path(local_directory, "Equatorial_Guinea_100m_Population.7z")
  worldpop_directory <- fs::path_ext_remove(local_file)
  remote_url <- "ftp://ftp.worldpop.org.uk/GIS/Population/Individual_countries/GNQ/Equatorial_Guinea_100m_Population.7z"

  if (!file.exists(local_file)) {
    curl::curl_download(remote_url, local_file, mode = "wb")
  }
  if (!dir.exists(worldpop_directory)) {
    dir.create(worldpop_directory)
    un7zip(local_file, worldpop_directory)
  }
  dir(worldpop_directory)
}


#' Retrieve Bioko grid data.
#'
#' Bioko grids are two shapefiles in UTM zone 32N projection.
#' The 100m grids are secs.shp and the 1km are mapareas.shp.
#' The two grids align in this projection.
#' @param local directory Where to put that file on the local machine.
#' @export
download_bioko_grids <- function(local_directory = "inst/extdata") {
  filename <- "Bioko_grids.zip"
  local_path <- fs::path(local_directory, filename)
  destination_directory <- fs::path_ext_remove(local_path)
  if (!file.exists(local_path)) {
    get_from_ihme(filename)
  }
  if (!dir.exists(destination_directory)) {
    dir.create(destination_directory)
  }
  unzip(local_path, exdir = destination_directory)
}
