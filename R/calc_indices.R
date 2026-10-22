#' @export
calc_indices <- function(
    input_path,
    output_path,
    expected_score_T2,
    cutoff,
    rel
) {

  worksheets <- readxl::excel_sheets(input_path)

  results <- worksheets |>
    purrr::map(\(worksheet) {

      run_analisys(
        path = input_path,
        worksheet = worksheet,
        expected_score_T2 = expected_score_T2,
        cutoff = cutoff,
        rel = rel
      )
    })

  # Preserve the worksheet names
  names(results) <- worksheets

  # Rename columns for outputs in Excel
  results_export <- results |>
    purrr::map(\(data) {
      data |>
        dplyr::rename(
          Id = id,
          "Reliable change index" = rci,
          "Cutoff score" = cutoff,
          "Confiability/Clinical significance" = final,
          Criterion = criterion
        )
    })

  writexl::write_xlsx(results_export, output_path)

  invisible(results_export)
}

