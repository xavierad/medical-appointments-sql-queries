
/*
-Query 1:
*/
create index employeeName_idx on employee(_name);

/*
-Query 2:
*/
create index srEval_idx on supervision_report(evaluation);
create index srDesc_idx on supervision_report(_description);
