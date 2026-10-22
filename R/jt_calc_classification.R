#'@export
calc_JT<- function(
    id,
    T1,
    T2,
    mean_disf = NULL,
    sd_disf = NULL,
    mean_func = NULL,
    sd_func = NULL,
    rel,
    cutoff,
    expected_score_T2
) {

  #-----------------------------------------------------------------------
  # validations

  # missing parameter warning
  if (any(rel < 0 || rel > 1, na.rm = TRUE)) {
    stop("The 'rel' argument must set between 0 and 1.")
  }

  # missing parameter warning
  if (any(sd_disf <= 0, na.rm = TRUE)) {
    stop("The population standart deviation must be greater than 0.")
  }

  # missing parameter warning
  if (!expected_score_T2 %in% c("higher", "lower")) {
    stop("Use 'higher' or 'lower' for the 'expected_score_T2 argument.")
  }

  #-----------------------------------------------------------------------
  # cutoff method definition

  if (cutoff == "A") {

    # missing parameter warning
    if (any(is.na(mean_disf)) || any(is.na(sd_disf))) {
      stop("To use Criterion A, include 'mean_disf' and 'sd_disf' in the appropriate worksheet columns.")
    }

    cutoff_val <- mean_disf + (2 * sd_disf)

  } else if (cutoff == "B") {

    # missing parameter warning
    if (any(is.na(mean_func)) || any(is.na(sd_func))) {
      stop("To use Criterion B, include 'mean_func' and 'sd_func' in the appropriate worksheet columns.")
    }

    cutoff_val <- mean_func - (2 * sd_func)

  } else if (cutoff == "C") {

    # missing parameter warning
    if (any(is.na(mean_func)) || any(is.na(sd_func))) {
      stop("To use Criterion C, include 'mean_func' and 'sd_func' in the appropriate worksheet columns.")
    }

    cutoff_val <- (sd_disf * mean_func + sd_func * mean_disf) /
      (sd_disf + sd_func)

  } else if (is.numeric(cutoff)) {

    cutoff_val <- cutoff

  } else {

    # missing parameter warning
    stop("The 'cutoff' argument must set 'A', 'B', 'C', or an integer (Standardized cutoff).")
  }

  #-----------------------------------------------------------------------------
  # RCI calc

  Sdiff <-  sd_disf * sqrt(2) * sqrt(1 - rel)

  # direction of improvement
  # (higher or loer scores in the post-test compared to the pre-test)
  if (expected_score_T2 == "higher") {

    # HIGHER post-intervention scores indicates better outcomes
    rci <- (T2 - T1) / Sdiff

    class_final <- dplyr::case_when(
      rci > 1.96 & T1 <= cutoff & T2 > cutoff_val ~ "Reliable improvement/Recovered",
      rci > 1.96 & T1 <= cutoff & T2 <= cutoff_val ~ "Reliable improvement/Improved",
      rci > 1.96 & T1 > cutoff & T2 > cutoff_val ~ "Reliable improvement",
      rci < -1.96 & T1 > cutoff & T2 < cutoff_val ~ "Reliable deterioration/Deteriorated",
      rci < -1.96 & ((T1 > cutoff & T2 > cutoff_val) |
                      (T1 < cutoff & T2 < cutoff_val)) ~ "Reliable deterioration/Worsened",
      TRUE ~ "No reliable change"
    )

  } else if (expected_score_T2 == "lower") {
    # LOWER post-intervention scores indicate better outcomes
    rci <- ((T2 - T1) / Sdiff) * -1

    class_final <- dplyr::case_when(
     rci > 1.96 & T1 >= cutoff & T2 < cutoff_val ~ "Reliable improvement/Recovered",
     rci > 1.96 & T1 >= cutoff & T2 >= cutoff_val ~ "Reliable improvement/Improved",
     rci > 1.96 & T1 < cutoff & T2 < cutoff_val ~ "Reliable improvement",
     rci < -1.96 & T1 < cutoff & T2 > cutoff_val ~ "Reliable deterioration/Deteriorated",
     rci < -1.96 & ((T1 < cutoff & T2 < cutoff_val) |
                     (T1 > cutoff & T2 > cutoff_val)) ~"Reliable deterioration/Worsened",
     TRUE ~ "No reliable change"
    )


  } else {

    # missing parameter warning
    stop("The 'expected_score_T2' argument must be either 'higher' or 'lower'.")

  }

  #-----------------------------------------------------------------------------

  criterion <- dplyr::case_when(
    cutoff == "A" ~ "A",
    cutoff == "B" ~ "B",
    cutoff == "C" ~ "B",
    TRUE ~ "Standardized cutoff"
  )


  # stores the results in a data frame
  data.frame(
    id = id,
    rci = round(rci, 2),
    cutoff = cutoff_val,
    final = class_final,
    criterion = criterion
  )
}
