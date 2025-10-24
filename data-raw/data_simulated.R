## code to prepare `data_simulated` dataset goes here

# data-raw/housepr_income.R
# ==========================================================
# Script to generate simulated datasets for the GoldinGroundOz package
# - Simulates household disposable income and detached house prices (1990–2023)
# - Simulates average capital gain rate change (1986–2020)
# ==========================================================

set.seed(35285397)

# ---- 1. Generate yearly sequence --------------------------------------------
year <- 1990:2023
n <- length(year)

# ---- 2. Simulate household disposable income data ---------------------------
income <- 100 + (year - 1990) * 6 + rnorm(n, mean = 0, sd = 6)

# ---- 3. Simulate detached house prices data ---------------------------------
house_price <- 100 * exp(0.06 * (year - 1990)) + rnorm(n, mean = 0, sd = 30)

# ---- 4. Combine as one dataset ---------------------------------------------
housepr_income <- data.frame(
  year = year,
  income = income,
  house_price = house_price
)

# ---- 5. Simulate Average Capital Gain Rate Change ---------------------------
years <- paste0(1986:2019, "-", substr(1987:2020, 3, 4))

# Label policy phase
phase <- ifelse(
  as.numeric(substr(years, 1, 4)) < 2000,
  "Before 50% capital gains discount",
  "After 50% capital gains discount"
)

# Generate yearly values for capital gains
values <- c(
  runif(sum(phase == "Before 50% capital gains discount"), 2500, 6000),
  seq(7000, 30000, length.out = sum(phase == "After 50% capital gains discount")) +
    rnorm(sum(phase == "After 50% capital gains discount"), 0, 1200)
)

# Keep all values positive
capital_gain <- data.frame(
  year = years,
  phase = phase,
  value = pmax(values, 0)
)

# ---- 6. Save both datasets to /data folder ----------------------------------
usethis::use_data(housepr_income, capital_gain, overwrite = TRUE)
