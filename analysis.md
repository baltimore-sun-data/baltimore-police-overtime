Analysis: Baltimore Police overtime in fiscal years 2018 and 2019
-----------------------------------------------------------------

The Baltimore Sun analyzed data on Baltimore police overtime provided by
the Baltimore Police Department in response to a public records request
for a Feb. 7, 2020 story titled [“Baltimore police binged on overtime,
racking up long hours with little oversight in past 2 years, records
show”](https://www.baltimoresun.com/maryland/baltimore-city/bs-md-ci-police-overtime-20200207-z43l2amv3vf3lb4rtgsvfeye6i-story.html).

Here are the key data elements reported in the story. Note the data in
the `input/` folder was pre-processed using the `cleaning.R` script.

-   The department’s tracking data obtained by the Sun contains
    inconsistencies and anomalies — in part due to “historical edits”
-   One officer averaged more than 45 hours a week in overtime for an
    entire year on top of his regular time.
-   Two more were paid for more than 2,000 hours of overtime
-   At least 17 recorded 1,700 hours or more
-   Officers often averaged more than 12 hours a day
-   Officers earned 64 hours or more of overtime during two-week periods
    at least 1,156 times in the past two fiscal years. Many repeated
    that pattern over and over
-   More than 50 officers routinely earned about 30 or 40 hours of
    overtime a week
-   Ethan Newberg, the highest paid officer in fiscal 2019, 2,229 hours
    of overtime that year
-   Newberg earned more than 70 hours of overtime in a pay period 16
    times during the 11 months he was on active duty during the fiscal
    year
-   During consecutive pay periods in September and October of 2018,
    Newberg collected at least 220 hours of overtime over four weeks
-   Newberg averaged about 46 hours of overtime per week for the 11
    months he was on duty
-   Officer Clarence Grear was paid $225,616 in fiscal 2019 and had the
    second most overtime hours at 2,221

### Load R libraries

``` r
library('tidyverse')
```

### Read in data

``` r
fy2018 <- read_csv('output/overtime_fy2018.csv')
fy2019 <- read_csv('output/overtime_fy2019.csv')
```

### Finding: The department’s tracking data obtained by the Sun contains inconsistencies and anomalies — in part due to “historical edits”

Although the data provided by the police department includes overtime
information by pay period, our story focuses on aggregate statistics for
the fiscal year. This is because officers sometimes saved up multiple
weeks of overtime slips and submitted them at once. For example, Brian
Rice, who was one of the six officers [charged and later
cleared](https://www.baltimoresun.com/news/crime/bs-md-ci-rice-trial-board-decision-20171117-story.html)
in the 2015 arrest and death of Freddie Gray, appeared to have worked
\~192 overtime hours in a single two-week pay period ending July 28,
2017.

``` r
fy2018 %>% filter(name.standardized == 'Rice,Brian S') %>% arrange(desc(gl_hours_paid)) %>% select(check_date, name.standardized, gl_pay_amount, gl_hours_paid) %>% head(1)
```

    ## # A tibble: 1 x 4
    ##   check_date name.standardized gl_pay_amount gl_hours_paid
    ##   <chr>      <chr>             <chr>                 <dbl>
    ## 1 7/28/2017  Rice,Brian S      $13,732.88             193.

However, according to an email from department spokesman Matt Jablow,
“Yes, he was paid for 192 overtime hours, which were historical edits
from May of 2017.” In a separate message, Jablow wrote:

    An historical edit is a payment for previous work.  There is a requirement in the new policy that officers turn in all overtime slips before their next regularly- scheduled tour of duty.  The goal is to significantly cut down on the number of historical edits. It will also allow the department to have more real-time data and, therefore, track and manage overtime spending more effectively than it has in the past.

Because we cannot rule out the possibility of that the amounts and hours
worked line items are historical edits rather than hours actually worked
over a given two-week time period, we decided to base the bulk of our
analyses on information aggregated over each fiscal year. For this
reason, we also use the word “earned,” “were paid,” or “recorded” when
referring to specific hours or dollar amounts officers were paid for
over a given two-week pay period, since we cannot be sure whether the
officers actually worked that amount or if they were paid for previous
overtime accrued at an earlier date in the fiscal year.

### Finding: One officer averaged more than 45 hours a week in overtime for an entire year on top of his regular time. Two more were paid for more than 2,000 hours of overtime

Create dataframes, `fy2019.totals` and `fy2018.totals`, which aggregate
the overtime hours (where `ep_entry_code` does not equal “REG”, or
regular pay) and amounts paid over fiscal 2019 and 2018 for each
officer.

``` r
fy2019.totals <-
fy2019 %>% filter(ep_entry_code != 'REG') %>% 
  group_by(emplid, name.standardized) %>% 
  summarise(total_amount = as.numeric(format(round(sum(amount)), nsmall = 2)),
            total_hours =  as.numeric(format(sum(gl_hours_paid),nsmall = 2))) 

fy2018.totals <-
  fy2018 %>% filter(ep_entry_code != 'REG') %>% 
  group_by(emplid, name.standardized) %>% 
  summarise(total_amount = as.numeric(format(round(sum(amount)), nsmall = 2)),
            total_hours =  as.numeric(format(sum(gl_hours_paid), nsmall = 2))) 
```

Ethan Newberg, a police sergeant [charged in
June](https://www.baltimoresun.com/news/crime/bs-md-ci-ethan-newberg-bodycam-20190614-story.html)
with assaulting a bystander and [later
indicted](https://www.baltimoresun.com/news/crime/bs-md-ci-cr-newberg-indicted-20191212-nm5kvghikrbofgir7pd4fzzkzy-story.html)
on 32 additional counts, was paid for a total of 2,229 hours of overtime
in fiscal 2019.

``` r
fy2019.totals %>% filter(name.standardized == 'Newberg,Ethan R')
```

    ## # A tibble: 1 x 4
    ## # Groups:   emplid [1]
    ##   emplid name.standardized total_amount total_hours
    ##   <chr>  <chr>                    <dbl>       <dbl>
    ## 1 025394 Newberg,Ethan R         156757       2229.

Newberg worked 47 weeks as he was suspended without pay in June 2019—the
final month of the fiscal year—meaning he worked a total of about 47
weeks in the fiscal year. We can divide the 2,229 hours by the 47 weeks
to get the average hours per week he worked in fiscal 2019.

``` r
print(paste("Newberg averaged", 
            round(fy2019.totals[fy2019.totals$name.standardized == 'Newberg,Ethan R',]$total_hours / 47, 1),
            "hours per week in fiscal 2019."))
```

    ## [1] "Newberg averaged 47.4 hours per week in fiscal 2019."

### Finding: Four more were paid for more than 2,000 hours of overtime

Sort `fy2018.totals` by `total_hours` to see how many officers were paid
for more than 2,000 hours.

``` r
fy2018.totals %>% arrange(desc(total_hours)) %>% head() 
```

    ## # A tibble: 6 x 4
    ## # Groups:   emplid [6]
    ##   emplid name.standardized      total_amount total_hours
    ##   <chr>  <chr>                         <dbl>       <dbl>
    ## 1 070896 Sanni-Ojikutu,Ismail O        95372       2057.
    ## 2 000612 Makanjuola,Rafiu T           114183       2034.
    ## 3 007574 Fleet,Theo D                 100224       1874.
    ## 4 045841 Grear,Clarence               105537       1874.
    ## 5 000993 White,Preston                 92703       1814.
    ## 6 061466 Debrosse,Dancy E              84197       1809.

That’s 2 officers in fiscal 2018.

Sort `fy2019.totals` by `total_hours` to see how many officers were paid
for more than 2,000 hours.

``` r
fy2019.totals %>% arrange(desc(total_hours)) %>% head()
```

    ## # A tibble: 6 x 4
    ## # Groups:   emplid [6]
    ##   emplid name.standardized  total_amount total_hours
    ##   <chr>  <chr>                     <dbl>       <dbl>
    ## 1 025394 Newberg,Ethan R          156757       2229.
    ## 2 045841 Grear,Clarence           135850       2221.
    ## 3 038624 Gross,Marvin J           113621       2153.
    ## 4 000612 Makanjuola,Rafiu T       120100       1996.
    ## 5 034675 Friend Jr,Frank J        133539       1977.
    ## 6 037936 Green,Eric L             116664       1951.

That’s 3 including Newberg. Since we already pointed out Newberg as
averaging more than 45 hours per week, we exclude him from this count: 2
in fiscal 2018 plus 2 (excluding Newberg) in 2019 = 4 additional
officers earning more than 2,000 hours.

### Finding: At least 17 recorded 1,700 hours or more

Filter `fy2018.totals` and `fy2019.totals` by `total_hours`and using
`nrow()` to see how many officers were paid for 1,700 hours or more.
Subtract 5 from the count because we have already included Newberg, plus
the 4 officers who earned 2,000+ hours.

``` r
print(paste(fy2019.totals %>% arrange(desc(total_hours)) %>% filter(total_hours > 1700) %>% nrow() + fy2018.totals %>% arrange(desc(total_hours)) %>% filter(total_hours > 1700) %>% nrow() - 5, "officers were paid for 1,700 hours or more (in addition to Newberg plus the four that earned more than 2,000."))
```

    ## [1] "25 officers were paid for 1,700 hours or more (in addition to Newberg plus the four that earned more than 2,000."

### Finding: Officers often averaged more than 12 hours a day

Calculate `per_day` as an estimated number of hours per day worked by an
officer by dividing `total_hours` by the number of weeks in fiscal year
by the number of days in a week, and add 8 assuming a normal 8 hour
daily shift (on top of which overtime is added). Here are somee examples
of officers averaging more than 12 hours a day.

``` r
fy2019.totals %>% mutate(per_day = ifelse(name.standardized == 'Newberg,Ethan R', 
                                                   total_hours/47/5 + 8,
                                                   total_hours/52/5 + 8)) %>% arrange(desc(per_day)) %>% 
  select(emplid, name.standardized, per_day) %>%
  head()
```

    ## # A tibble: 6 x 3
    ## # Groups:   emplid [6]
    ##   emplid name.standardized  per_day
    ##   <chr>  <chr>                <dbl>
    ## 1 025394 Newberg,Ethan R       17.5
    ## 2 045841 Grear,Clarence        16.5
    ## 3 038624 Gross,Marvin J        16.3
    ## 4 000612 Makanjuola,Rafiu T    15.7
    ## 5 034675 Friend Jr,Frank J     15.6
    ## 6 037936 Green,Eric L          15.5

### Officers earned 64 hours or more of overtime during two-week periods at least 1,156 times in the past two fiscal years. Many repeated that pattern over and over

Filter `fy2019` and `fy2018` to include only overtime pay (where
`ep_entry_code` does not equal “REG”, or regular pay). Each row is a
2-week pay period ending on a given date `date`.

Note that an officer can be paid several times in a given 2-week pay
period. For example, Ethan Newberg on May 31, 2019:

``` r
fy2019 %>% filter(ep_entry_code != 'REG' & name.standardized == 'Newberg,Ethan R') %>% 
  select(emplid, date, name.standardized, gl_pay_amount, gl_hours_paid) %>% filter(date == '2019-05-31') %>% arrange(desc(gl_hours_paid))
```

    ## # A tibble: 4 x 5
    ##   emplid date       name.standardized gl_pay_amount gl_hours_paid
    ##   <chr>  <date>     <chr>             <chr>                 <dbl>
    ## 1 025394 2019-05-31 Newberg,Ethan R   $3,045.48                41
    ## 2 025394 2019-05-31 Newberg,Ethan R   $1,708.44                23
    ## 3 025394 2019-05-31 Newberg,Ethan R   $891.36                  12
    ## 4 025394 2019-05-31 Newberg,Ethan R   $594.24                   8

Again, we are unsure which items are historical edits for past overtime
hours worked. To make a conservative estimate, in such cases, we do
*not* add up the amounts by pay period for each officer. For this
reason, we use the term “at least” in the story.

Filter by `gl_hours_paid` and add up how many times (at least) officers
earned 64 hours or more during fiscal 2018 and 2019.

``` r
print(paste("Officers earned 64 hours or more of overtime during two-week periods at least", fy2019 %>% filter(ep_entry_code != 'REG' & gl_hours_paid >= 64) %>% nrow() + fy2018 %>% filter(ep_entry_code != 'REG' & gl_hours_paid >= 64) %>% nrow(), "times in fiscal 2018 and 2019."))
```

    ## [1] "Officers earned 64 hours or more of overtime during two-week periods at least 1156 times in fiscal 2018 and 2019."

We can see that many repeated this pattern over and over by grouping by
officer and sorting by the number of times they appear in the database -
many appear very often. Here’s fiscal 2019 for example:

``` r
fy2019 %>% filter(ep_entry_code != 'REG' & gl_hours_paid >= 64) %>% 
  group_by(emplid, name.standardized) %>%
  mutate(n = n()) %>%
  arrange(-n) %>% 
  select(n, emplid, date, name.standardized, gl_pay_amount, gl_hours_paid)
```

    ## # A tibble: 553 x 6
    ## # Groups:   emplid, name.standardized [230]
    ##        n emplid date       name.standardized gl_pay_amount gl_hours_paid
    ##    <int> <chr>  <date>     <chr>             <chr>                 <dbl>
    ##  1    16 025394 2018-12-14 Newberg,Ethan R   $6,041.46              88.9
    ##  2    16 025394 2018-11-02 Newberg,Ethan R   $5,244.58              77.2
    ##  3    16 025394 2019-01-11 Newberg,Ethan R   $5,584.26              82.2
    ##  4    16 025394 2019-02-22 Newberg,Ethan R   $7,197.73              96.9
    ##  5    16 025394 2019-04-18 Newberg,Ethan R   $6,505.44              87.6
    ##  6    16 025394 2018-10-05 Newberg,Ethan R   $7,313.20             108. 
    ##  7    16 025394 2019-02-08 Newberg,Ethan R   $5,271.65              71.0
    ##  8    16 025394 2019-01-25 Newberg,Ethan R   $6,393.62              91.4
    ##  9    16 025394 2019-03-08 Newberg,Ethan R   $7,747.40             104. 
    ## 10    16 025394 2019-03-22 Newberg,Ethan R   $7,383.43              99.4
    ## # … with 543 more rows

### Finding: More than 50 officers routinely earned about 30 or 40 hours of overtime a week

Use the fiscal year 2019 and 2018 total hours to calculate an estimated
average hours per week by dividing by 52 (or 47 in the case of Newberg)
and filter to more than 30 (the max is Newberg at about 47 in fiscal
2019).

``` r
print(paste(fy2019.totals %>% 
  mutate(per_week = ifelse(name.standardized == 'Newberg,Ethan R', 
                           total_hours/47,
                           total_hours/52)) %>%
  arrange(-per_week) %>%
  filter(per_week >= 30) %>%
  nrow() + fy2018.totals %>% 
  mutate(per_week = total_hours/52) %>%
  arrange(-per_week) %>%
  filter(per_week >= 30) %>%
  nrow(), "officers earned about 30 or 40 hours of overtime a week"))
```

    ## [1] "57 officers earned about 30 or 40 hours of overtime a week"

### Finding: Ethan Newberg, [the highest paid officer in fiscal 2019](https://www.baltimoresun.com/maryland/baltimore-city/bs-md-ci-baltimore-city-salaries-20191007-3dxreljal5b3jgbmfzgx2ic7dm-story.html), earned 2,229 hours of overtime that year

Filter `fy2019.totals` to Newberg.

``` r
print(paste("Newberg earned",
      fy2019.totals[fy2019.totals$name.standardized == 'Newberg,Ethan R',]$total_hours,
      "hours of overtime in fiscal 2019."))
```

    ## [1] "Newberg earned 2228.9 hours of overtime in fiscal 2019."

### Finding: Newberg earned more than 70 hours of overtime in a pay period 16 times during the 11 months he was on active duty during the fiscal year

Filter `fy2019` to include Newberg’s overtime pay and 70+ hours worked
to see how many times he recorded more than 70 hours of overtime per pay
period.

``` r
print(paste("Newberg recorded more than 70 hours of overtime",
            fy2019 %>% filter(ep_entry_code != 'REG' & grepl('Newberg', name.standardized) & gl_hours_paid >= 70) %>% nrow(),
            "times in a pay period fiscal 2019."))
```

    ## [1] "Newberg recorded more than 70 hours of overtime 16 times in a pay period fiscal 2019."

### Finding: During consecutive pay periods in September and October of 2018, Newberg collected at least 220 hours of overtime over four weeks

This was in the pay periods ending 2018-09-21 and 2018-10-05, where
Newberg collected (at least) 107.65 and 112.90 hours, respectively.

``` r
fy2019 %>% filter(ep_entry_code != 'REG' & grepl('Newberg',name.standardized)) %>% arrange(desc(gl_hours_paid)) %>% 
  head(2) %>% 
  select(emplid, date, name.standardized, gl_pay_amount, gl_hours_paid)
```

    ## # A tibble: 2 x 5
    ##   emplid date       name.standardized gl_pay_amount gl_hours_paid
    ##   <chr>  <date>     <chr>             <chr>                 <dbl>
    ## 1 025394 2018-09-21 Newberg,Ethan R   $7,669.86              113.
    ## 2 025394 2018-10-05 Newberg,Ethan R   $7,313.20              108.

### Finding: Newberg averaged about 46 hours of overtime per week for the 11 months he was on duty

See “Finding: One officer averaged more than 45 hours a week in overtime
…”

### Finding: Officer Clarence Grear was paid $225,616 in fiscal 2019 and had the second most overtime hours at 2,221

Grear’s total pay for fiscal 2019, $225,616, is in the table at the
bottom of [this
story](https://www.baltimoresun.com/maryland/baltimore-city/bs-md-ci-baltimore-city-salaries-20191007-3dxreljal5b3jgbmfzgx2ic7dm-story.html).
Arrange `fy2019.totals` by `total_hours` — Grear is \#2 at about 2221
hours of overtime in fiscal 2019.

``` r
fy2019.totals %>% arrange(desc(total_hours)) %>% head(10)
```

    ## # A tibble: 10 x 4
    ## # Groups:   emplid [10]
    ##    emplid name.standardized      total_amount total_hours
    ##    <chr>  <chr>                         <dbl>       <dbl>
    ##  1 025394 Newberg,Ethan R              156757       2229.
    ##  2 045841 Grear,Clarence               135850       2221.
    ##  3 038624 Gross,Marvin J               113621       2153.
    ##  4 000612 Makanjuola,Rafiu T           120100       1996.
    ##  5 034675 Friend Jr,Frank J            133539       1977.
    ##  6 037936 Green,Eric L                 116664       1951.
    ##  7 082790 Conley III,James L            97456       1923.
    ##  8 061466 Debrosse,Dancy E              94974       1868.
    ##  9 096540 Zaza,Zaebele M                64909       1800.
    ## 10 070896 Sanni-Ojikutu,Ismail O        89866       1775.

### Formatting for chart and tables

Format the top 10 in fiscal 2019 data as well as the fiscal 2019 totals
for chart and tables included in the story.

``` r
fy2019.totals <-
separate(fy2019.totals, 
         name.standardized,
         into = c('last', 'first_middle'),
         sep = ',',
         remove = F) 

fy2019.totals <- separate(fy2019.totals, 
                          first_middle, 
                          into = c('first', 'middle'),
                          sep = " ",
                          remove = F) %>% 
  mutate(name_format = ifelse(is.na(middle), paste0(first, " ", last),
                paste0(first, " ", middle, ". ", last)))
```

    ## Warning: Expected 2 pieces. Additional pieces discarded in 8 rows [329,
    ## 513, 613, 999, 1193, 1272, 1779, 2551].

    ## Warning: Expected 2 pieces. Missing pieces filled with `NA` in 294 rows
    ## [4, 15, 16, 18, 20, 24, 36, 37, 38, 39, 40, 48, 50, 53, 54, 61, 68, 71, 74,
    ## 75, ...].

``` r
fy2019.totals %>% ungroup() %>% select(name_format, total_amount, total_hours) %>% arrange(desc(total_hours)) %>% head(10) %>% write_csv('output/fy19_hours_top10.csv')

fy2019.totals %>% ungroup() %>% mutate(amount_k_format = round(total_amount/1000, 1),
                  hours_format = round(total_hours, 1)) %>% 
  arrange(desc(total_hours)) %>% 
  filter(hours_format >= 8) %>% 
  select(name_format, hours_format, amount_k_format) %>%
  write_csv('output/fy19_table_format.csv')
```
