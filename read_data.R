# SpatialPolygonsDataFrame was taken from rusmaps package
# Then it was converted to dataframe using broom::tidy

ggrmap <- readRDS("data/rmap_clean_id.rds")


# Same map without interval variables
# rds_map <- readRDS("data/rdsmap.rds")

# Additional id
# ggrmap$id_clean <- ggrmap$id
# 
# 
# ggrmap$id_clean <- tolower(ggrmap$id_clean)
# ggrmap$id_clean <- gsub("[[:space:]]", "", ggrmap$id_clean)
# ggrmap$id_clean <- gsub("[[:punct:]]", "", ggrmap$id_clean)

