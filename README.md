Goal:

* Create a pipeline to stack and clean a number of *.txt files

From:

Institution.ID | Test.Date.s. | Order.Number | Exam | ID | Examinee | Total.Test.Equated.Percent.Correct.Score | ...
-------------- | ------------ | ------------ | ---- | -- | -------- | ---------------------------------------- | ---

To:

student_id | wh_date | wh_score | wh_fail | peds_date | peds_score | peds_fail | ...
---------- | ------- | -------- | ------- | --------- | ---------- | --------- | ---

More about rotations:

* Each academic year, students get put into 6 groups
* Each group "rotates" through 6 rotations (women's health, pediatrics, etc) in different order
* At the end of each rotation, each group takes a standardized exam through a third party vendor
