# Baltimore Police overtime in fiscal years 2018 and 2019

## Baltimore Sun analysis

By [Christine Zhang](mailto:czhang@baltsun.com)

The Baltimore Sun obtained salary and overtime reords for around 3,000 police officers over fiscal years 2018 and 2019 from the Baltimore Police Department. Our analysis of these records provided information for a February 7, 2020 Baltimore Sun story titled ["Baltimore police racked up overtime by working long hours with little oversight in past 2 years, records show
"](https://www.baltimoresun.com/maryland/baltimore-city/bs-md-ci-police-overtime-20200207-z43l2amv3vf3lb4rtgsvfeye6i-story.html)

The Sun's findings and analysis are available in the "analysis" markdown file in this repository: [`analysis.md`](xxxxx). The pre-processing code is in the [`cleaning.R`](xxx) file in this repository.

**Note:** The Police Department's data contains inconsistencies and anomalies, primarily due to "historical edits," which represent overtime hours and pay for past overtime hours worked. Because we cannot rule out the possibility of that the amounts and hours worked line items are historical edits rather than hours actually worked over a given two-week time period, we decided to base the bulk of our analyses on information aggregated over each fiscal year. See [`analysis.md`](xxxxx) for more information.

If you'd like to run the code yourself in R, you can download the R Markdown file [`cleaning.R`](xxx) and [`analysis.Rmd`](xxx) along with the data in the `input` folder.

The raw datasets are saved in the `input` folder.  The cleaned data to is in the `output` folder under [`overtime_fy2018.csv`](xxx) and [`overtime_fy2019.csv`](xxx). These two files are also provided in a Google folder, available at xxxx.

https://twitter.com/baltsundata

## Community Contributions

There are many angles to explore with this data, beyond just the ones we looked into for our story. 

**Have something to contribute?** Send us a pull request or contact us on Twitter [@baltsundata](https://twitter.com/baltsundata) or via [email](mailto:czhang@baltsun.com).

You can also fork a copy of this repo to your own account.

## Licensing

All code in this repository is available under the [MIT License](https://opensource.org/licenses/MIT). The data files are available under the [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/) (CC BY 4.0) license.