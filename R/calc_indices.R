#'@export
calc_indices <- function(
    input_path,
    output_path,
    expected_score_T2,
    cutoff,
    rel
) {

  data2 <- readxl::excel_sheets(input_path)

  results <- data2 |>
    purrr::map(\(worksheet){

      run_analisys(
        path = input_path,
        worksheet = worksheet,
        expected_score_T2 = expected_score_T2,
        cutoff = cutoff,
        rel = rel
      )
    })

  names(results) <- data2

  writexl::write_xlsx(results, output_path)

  invisible(results)

}
