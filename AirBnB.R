# Designate "ID" Colname throughout data sets
colnames(Calendar)[1]<- "ID"
colnames(Listings)[1]<- "ID"
colnames(Reviews)[1]<- "ID"

df<- merge(Listings, Reviews, by = c( "ID" ), all = TRUE)

#Remove $ from Nightly Rate/Price
df$price = as.numeric(gsub("\\$", "", df$price))

BB<- df

#Select required columns for hypotheses
DFNoFilt <- BB[c("ID", "host_id", "host_since", "zipcode", "latitude", "longitude", "property_type", "room_type", "price", "review_scores_rating", "comments")]

#Change column names
names(DFNoFilt)[2]<- "Host ID"
names(DFNoFilt)[3]<- "Host Since"
names(DFNoFilt)[4]<- "Zip Code"
names(DFNoFilt)[5]<- "Latitude"
names(DFNoFilt)[6]<- "Longitude"
names(DFNoFilt)[7]<- "Property Type"
names(DFNoFilt)[8]<- "Room Type"
names(DFNoFilt)[9]<- "Price"
names(DFNoFilt)[10]<- "Review Score"
names(DFNoFilt)[11]<- "Comments"

#Filter Initiak Users
FIRST <- DFNoFilt %>%
  + filter(str_detect(DFNoFilt$Comments, paste(c("first time", "first experience", "First time", "First experience"), collapse = '|')))

#Remove all Initial users from original dataset
NoFirst <- filter(DFNoFilt, !grepl(paste(minus, collapse = "|"), DFNoFilt$Comments))

#FInd Averages of Inintial and Noninital nightly price and review score
mean(FIRST$Price)                                                  # First time user avg Price = $102.58/Night
mean(NoFirst$Price, na.rm = TRUE)                                  # Noninitial user avg Price = $109.20/Night
mean(FIRST$`Review Score`)                                         # First time user avg accomodation rating score = 95.42
mean(NoFirst$`Review Score`, na.rm = TRUE)                         # Noninitial user avg accomodation rating score = 94.88

# First time Airbnb users in Seattle will spend an average of $6.62 less nightly but rate an accomodation 0.54 points higher


#Find dates of first and last reviews
Reviews[order(Reviews$date),]
# First time Airbnb users in  Seattle only make up 2.78% of total users that provided feedback from  to 2009-06-07 to 2016-01-03

# Change Host_since to as.Date from factor (For Noninitail Users)
DFNoFilt$`Host Since` <- as.Date(DFNoFilt$`Host Since`)
DFNoFilt$`Host Since` <- as.Date(DFNoFilt$`Host Since`, "%Y/%m/%d")


# Find time difference in years between host start date and present date (Noninitial)
DFNoFilt$Today<- "2019-02-28"
DFNoFilt$Today<- as.Date(DFNoFilt$Today, "%Y/%m/%d")
DFNoFilt$Diff <- DFNoFilt$Today - DFNoFilt$`Host Since`
DFNoFilt$Diff <- DFNoFilt$Diff / 365

# Change Host_since to as.Date from factor (For Initail Users)
FIRST$`Host Since` <- as.Date(FIRST$`Host Since`)

# Find time difference in years between host start date and present date (Initial)
FIRST$Today <- "2019-02-28"
FIRST$Today <- as.Date(FIRST$Today)
FIRST$Diff <- FIRST$Today - FIRST$`Host Since`
FIRST$Diff <- FIRST$Diff / 365


