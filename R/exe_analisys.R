#'@export
run_analisys <- function(path,
                         worksheet,
                         expected_score_T2,
                         cutoff,
                         rel) {

  data <- readxl::read_excel(path,
                             sheet = worksheet)

  data <- readxl::read_excel(path,
                             sheet = worksheet) |>
    dplyr::mutate(
      dplyr::across(
        c(mean_disf,
          sd_disf,
          mean_func,
          sd_func),
        ~ as.numeric(.)
      )
    )

  result <- calc_JT(
    id = data$id,
    T1 = data$T1,
    T2 = data$T2,
    mean_disf = data$mean_disf,
    sd_disf = data$sd_disf,
    mean_func = data$mean_func,
    sd_func = data$sd_func,
    rel = rel,
    cutoff = cutoff,
    expected_score_T2 = expected_score_T2
  )

  return(result)

}
