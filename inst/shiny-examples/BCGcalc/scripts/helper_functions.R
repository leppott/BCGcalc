# Helper functions so can repeat code without repeating the code
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com
# 2023-11-06
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

clean_results <- function() {
# Remove results folder contents
# Create subfolders
# Copy input file  
  
  # Remove all files in "Results" folder
  # Triggered here so can run different files
  fn_results <- list.files(path_results
                           , full.names = TRUE
                           , include.dirs = TRUE
                           , recursive = TRUE)
  message(paste0("Files and folders in 'results' folder (before removal) = "
                 , length(fn_results)))
  # file.remove(fn_results) # ok if no files and only files
  unlink(fn_results, recursive = TRUE) # includes directories
  # QC, repeat 
  fn_results2 <- list.files(path_results
                            , full.names = TRUE
                            , include.dirs = TRUE
                            , recursive = TRUE)
  message(paste0("Files in 'results' folder (after removal [should be 0]) = "
                 , length(fn_results2))) 
  
}## clean_results

#' @param import_file Imported file, input$fn_input
#
copy_import_file <- function(import_file) {
  
  # result folder and files
  path_results_sub <- file.path(path_results, dn_files_input)
  
  # Add "Results" sub folder if missing
  boo_Results <- dir.exists(file.path(path_results_sub))
  if (boo_Results == FALSE) {
    dir.create(file.path(path_results_sub))
  }
  
  # Copy to "Results" sub-folder - Import "as is"
  file.copy(import_file$datapath, file.path(path_results_sub
                                               , import_file$name))
  
}## copy_import_file


