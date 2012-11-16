sum_list([], 0).
sum_list([H | Rest], Sum) :- sum_list(Rest,Tmp), Sum is (H > 0 -> H + Tmp ; Tmp).

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
  add_category_min_score([],'Code-Review', 4, NewLabels),
  S =.. [submit | NewLabels].
