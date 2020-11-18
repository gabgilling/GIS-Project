# GIS-Project
Environmental Voter Preferences in Congressional Districts with GHG Emitting Facilities

I am interested in seeing whether the presence of Greenhouse Gas (GHG) Emitting Facilities affects the preferences for environmental regulation for voters in Census Districts (CDs) across the United States.

The first step was to get the shape files for the CDs from the U.S. government, accessible [here](https://catalog.data.gov/dataset/tiger-line-shapefile-2018-nation-u-s-116th-congressional-district-national). My analysis focuses on the 116th Congressional District, with survey data from the [Cooperative Congressional Election Study](https://cces.gov.harvard.edu/), which surveys Americans every year on a wide array of different topics, including questions about the environment. I used 2 year's worth of data, for [2018](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910/DVN/ZSBZ7K) and [2019](https://dataverse.harvard.edu/file.xhtml?fileId=4101256&version=1.0). The raw data and survey questionnaires can be found there.

Then, I downloaded the location of the GHG facilities from the [EPA](https://ghgdata.epa.gov/ghgp/main.do#) using locations for 2019. For the sake of this first analysis, I am using all of the facilities in the sample, although I will probably filter some more down the road.

Before I could map anything out, I had to merge the preference data to the CD shape file. In order to do so, I created an index by averaging the mean level of support for environment related questions by CD for both 2018 and 2019. Higher values for the dependent variable *pref_index* indicate favorable opinions for regulation, and vice versa. I then loaded in the .dbf file associated with the CD polygons and merge the preferences into it. You can find all of the code in the wrangle.R file in the repo.

Let's look at the distribution of the preferences:
![env_prefs](/Plots/epi.png)

