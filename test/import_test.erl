-module(import_test).

-include_lib("eunit/include/eunit.hrl").

-define(EXPORTS(Mod), Mod:module_info(exports)).

single_test_() ->
    [{<<"All functions on 'single' stubbed properly">>,
     [?_assert(lists:member({doit, 0}, ?EXPORTS(single))),
      ?_assert(lists:member({doit, 1}, ?EXPORTS(single))),
      ?_assert(lists:member({doit, 2}, ?EXPORTS(single)))]},
     {<<"All functions on 'single' work correctly">>,
      [?_assertMatch(doit, single:doit()),
       ?_assertMatch([doit, 1], single:doit(1)),
       ?_assertMatch([doit, 1, 2], single:doit(1, 2))]}].

multiple_test_() ->
    [{<<"All functions stubbed">>,
      [?_assert(lists:member({doit, 0}, ?EXPORTS(multiple))),
       ?_assert(lists:member({doit, 1}, ?EXPORTS(multiple))),
       ?_assert(lists:member({doit, 2}, ?EXPORTS(multiple))),
       ?_assert(lists:member({canhas, 0}, ?EXPORTS(multiple))),
       ?_assert(lists:member({canhas, 1}, ?EXPORTS(multiple)))]},
     {<<"All stubbed functions work">>,
      [?_assertMatch(doit, multiple:doit()),
       ?_assertMatch({doit, one}, multiple:doit(one)),
       ?_assertMatch([doit, one, two], multiple:doit(one, two)),
       ?_assert(multiple:canhas()),
       ?_assertMatch(cheezburger, multiple:canhas(cheezburger))]}].

alias_test_() ->
    [{<<"Function stubbed with alias">>,
      [?_assert(lists:member({blah, 0}, ?EXPORTS(alias))),
       ?_assert(lists:member({can_has, 0}, ?EXPORTS(alias)))]},
     {<<"All stubbed functions work">>,
      [?_assertMatch(doit, alias:blah()),
       ?_assertMatch(true, alias:can_has())]}].

override_test_() ->
    [{<<"All non-overridden functions are stubbed">>,
      [?_assert(lists:member({doit, 0}, ?EXPORTS(override))),
       ?_assert(lists:member({doit, 1}, ?EXPORTS(override))),
       ?_assert(lists:member({doit, 2}, ?EXPORTS(override)))]},
     {<<"All functions work as expected">>,
      [?_assertMatch(doit, override:doit()),
       ?_assertMatch([5,5], override:doit(5)),
       ?_assertMatch([doit, 5, 10], override:doit(5, 10))]}].

reserved_test_() ->
    [{<<"Use reserved words as function name">>,
      [?_assertEqual(['or', "a", "b"], single:'or'("a", "b")),
       ?_assertEqual(['or_override', "a", "b"], override:'or'("a", "b"))]}].

invalid_atom_format_test_() ->
    [{<<"Use non-alphanumeric atom as function name">>,
      [?_assertEqual(['a_function', "a"], single:'a-function'("a")),
       ?_assertEqual(['a_function_override', "a"], override:'a-function'("a")),
       ?_assertEqual(['camel'], single:'CamelCaseFunction WithSpaces'()),
       ?_assertEqual(['camel_override'], override:'CamelCaseFunction WithSpaces'()),
       ?_assertEqual(['camel', "a"], single:'CamelCaseFunction WithSpaces'("a")),
       ?_assertEqual(['camel_override', "a"], override:'CamelCaseFunction WithSpaces'("a"))]}].
