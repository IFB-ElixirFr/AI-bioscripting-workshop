##### Parameters #####

# Table of oscillating genes
url_expression <- "https://ifb-elixirfr.github.io/AI-for-scripting-bioanalysis/data/yeast-transcriptome-cell-cycle/oscillating-genes_normalized-profiles.tsv"

# Define output directory. Create it if it does not exist, and check if the directory is writable. Else, issue an error.
output_dir <- "results"
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}
if (!file.access(output_dir, 2) == 0) {
  stop("Output directory is not writable: ", output_dir)
}

# Install necessary libraries only if they are not already installed
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}
if (!requireNamespace("writexl", quietly = TRUE)) {
  install.packages("writexl")
}

# Load necessary libraries
library(tidyverse)
library(writexl)

##### A functionthat downloads the oscillating genes table and store a local copy if not yet there ####
##### This function is used to download the oscillating genes table from a URL and save it locally if it does not already exist.

download_oscillating_genes <- function(url, local_file) {
  if (!file.exists(local_file)) {
    download.file(url, local_file, method = "curl")
    message("File downloaded and saved as \n\t", local_file)
  } else {
    message("File already exists: \n\t", local_file)
  }
}


##### Download the oscillating genes table #####
##### This code downloads the oscillating genes table from a specified URL and saves it locally if it does not already exist.
##### The local file is named "oscillating-genes_normalized-profiles.tsv" and is stored in the output directory.
##### Define a file path for the local copy of the oscillating genes table
profiles_file <- file.path(output_dir, "oscillating-genes_normalized-profiles.tsv")
download_oscillating_genes(url_expression, profiles_file)
##### Check if the file has been downloaded successfully #####
##### This code checks if the file has been downloaded successfully by verifying its existence. If the file does not exist, it stops the execution with an error message.

if (!file.exists(profiles_file)) {
  stop("The file 'oscillating-genes_normalized-profiles.tsv' could not be downloaded or does not exist.")
} else {
  message("The file 'oscillating-genes_normalized-profiles.tsv' has been downloaded successfully locally: \n\t", 
          profiles_file)
}

##### Read the oscillating genes table #####

##### This code reads the oscillating genes table from a local file and stores it in a variable called `oscillating_genes`.

oscillating_genes <- read.csv(profiles_file, 
                              sep = "\t", row.names = 1, header = TRUE)

#### Unit test : check that the file has been properly downloaded, is a tab-separated file, and is not empty #####
#### This code checks if the downloaded file exists, is a tab-separated file, and is not empty. If any of these conditions are not met, it stops the execution with an error message.
if (!file.exists(profiles_file)) {
  stop("File does not exist.")
}
if (tools::file_ext(profiles_file) != "tsv") {
  stop("File is not a tab-separated file.")
}
if (file.size(profiles_file) == 0) {
  stop("File is empty.")
}
##### Display the dimensions of the oscillating genes table and check that it conforms to the expectation: 50 colums and 1705 rows #####
##### This code displays the dimensions of the oscillating genes table and checks that it has 50 columns and 1705 rows. If the dimensions do not match, it stops the execution with an error message.
##### If not, issue a well-documented error ####

dim_oscillating_genes <- dim(oscillating_genes)
if (dim_oscillating_genes[1] != 1705 || dim_oscillating_genes[2] != 50) {
  stop("The oscillating genes table does not have the expected dimensions: 1705 rows and 50 columns.")
} else {
  message("The oscillating genes table has the expected dimensions: ", 
          dim_oscillating_genes[1], " rows and ", dim_oscillating_genes[2], " columns.")
}

#### Normalize the expression values in the oscillating genes table #####
#### 1. Apply log2 ( x + 1) transformation to the expression values in the oscillating genes table.

oscillating_genes_log2 <- log2(oscillating_genes + 1)

#### 2. Normalize columns (samples) by dividing each column by the maximum value in that column.

oscillating_genes_norm_col <- oscillating_genes_log2 / apply(oscillating_genes_log2, 2, max)

#### 3. Normalize rows (genes) by subtracting the mean and dividing by the standard deviation of each row.

oscillating_genes_norm <- t(apply(oscillating_genes_norm_col, 1, function(x) {
  (x - mean(x)) / sd(x)
}))

#summary(oscillating_genes_norm)
#View(oscillating_genes_norm)

#### Compute a distance matrix between each pair of rows (genes) in the oscillating genes table #####
#### This code computes a distance matrix between each pair of rows (genes) in the oscillating genes table using the `dist` function with the "euclidean" method. The resulting distance matrix is stored in a variable called `distance_matrix`.
#### Use the correlation distance instead of the Euclidian distance #####
#### THe correlation distance is defined as 1 - r, where r is the pearson correlation coefficient between the two vectors.

distance_matrix <- as.matrix(dist(1 - cor(t(oscillating_genes_norm), method = "pearson")))

##### Check that the dimensions of the distance matrix correspond to the number of rows (genes) of the normalised expression tabole #####

##### This code checks that the dimensions of the distance matrix correspond to the number of rows (genes) in the normalized expression table. If the dimensions do not match, it stops the execution with an error message.
##### else issue a message indicating that the distance matrix has been computed successfully.

if (dim(distance_matrix)[1] != nrow(oscillating_genes) || 
    dim(distance_matrix)[2] != nrow(oscillating_genes)) {
  stop("The distance matrix does not have the expected dimensions: ", 
       nrow(oscillating_genes), " rows and ", nrow(oscillating_genes), " columns.")
} else {
  message("The distance matrix has been computed successfully with dimensions: ", 
          dim(distance_matrix)[1], " rows and ", dim(distance_matrix)[2], " columns.")
}

##### Save the distance matrix to a file #####
# Define path for the distance matrix file in the output directory
distance_matrix_file <- file.path(output_dir, "distance_matrix.tsv")
write.table(distance_matrix, file = distance_matrix_file, 
            sep = "\t", row.names = TRUE, col.names = NA, quote = FALSE)
#### Check that the distance matrix has been saved successfully ####
if (!file.exists(distance_matrix_file)) {
  stop("The distance matrix could not be saved or does not exist.")
} else {
  message("The distance matrix has been saved successfully as\n\t", 
          distance_matrix_file)
}

#### Save in the output directory the distance matrix in excel format, including row names (gene IDs) as a column ####
#### This code saves the distance matrix in Excel format using the `writexl` package. The row names (gene IDs) are included as a column in the Excel file. The resulting file is named "distance_matrix.xlsx" and is stored in the output directory.

distance_matrix_excel_file <- file.path(output_dir, "distance_matrix.xlsx")
write_xlsx(cbind(geneID=row.names(distance_matrix), as.data.frame(distance_matrix)),
           distance_matrix_excel_file)
if (!file.exists(distance_matrix_excel_file)) {
  stop("The distance matrix could not be saved in Excel format or does not exist.")
} else {
  message("The distance matrix has been saved successfully in Excel format as\n\t", 
          distance_matrix_excel_file)
}
# system(paste("open", output_dir))

#### Use singular value decomposition to reduce produce a 2D map of the genes ###

#### This code uses singular value decomposition (SVD) to reduce the dimensionality of the distance matrix and produce a 2D map of the genes. The resulting 2D coordinates are stored in a variable called `svd_coordinates`.

svd_result <- svd(distance_matrix)
svd_coordinates <- data.frame(
  X = svd_result$u[, 1],
  Y = svd_result$u[, 2],
  Gene = rownames(distance_matrix)
)

## Plot genes on a 2D map according to their SVD coordinates ####
## Dispolay each gene as a simple dot, without label ##
## Assign a color to each gene according to the time point of its maximum expression value in the oscillating genes table.

library(ggplot2)
svd_coordinates$TimePoint <- apply(oscillating_genes, 1, function(x) {
  which.max(x)
})
#### This code assigns a time point to each gene based on the maximum expression value in the oscillating genes table. The time point is determined by finding the index of the maximum value in each row (gene) of the oscillating genes table.

#### This code plots the genes on a 2D map according to their SVD coordinates using the `ggplot2` package. Each gene is represented as a point, and the color of each point corresponds to the time point of its maximum expression value in the oscillating genes table.
#### The resulting plot is saved as a PNG file named "svd_coordinates_plot.png" in the output directory.

ggplot(svd_coordinates, aes(x = X, y = Y, color = as.factor(TimePoint))) +
  geom_point() +
  labs(title = "SVD Coordinates of Oscillating Genes",
       x = "SVD Component 1",
       y = "SVD Component 2",
       color = "Time Point") +
  theme_minimal()
