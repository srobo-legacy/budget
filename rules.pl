sum_list([], 0).
sum_list([H | Rest], Sum) :- sum_list(Rest, Tmp), H > 0, Sum is H + Tmp.
sum_list([H | Rest], Sum) :- sum_list(Rest, Sum), H =< 0.

add_category_min_score(In, Category, Min,  P) :-
  findall(X, gerrit:commit_label(label(Category,X),R),Z),
  sum_list(Z, Sum),
  Sum >= Min, !,
  P = [label(Category,ok(R)) | In].

add_category_min_score(In, Category,Min,P) :-
  P = [label(Category,need(Min)) | In].

submit_rule(S) :-
  gerrit:default_submit(X),
  X =.. [submit | Ls],
  add_category_min_score([],'Code-Review', 3, NewLabels),
  S =.. [submit | NewLabels].
