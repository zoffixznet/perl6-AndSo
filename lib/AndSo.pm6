use RakudoPrereq v2017.04.3, 'AndSo module requires Rakudo v2017.04.3 or newer';
use nqp;
use NQPHLL:from<NQP>;

sub EXPORT(|) {
    my role AndSo {
        my %loose_andthen =
            'prec', 'd=', 'assoc', 'left', 'dba', 'loose and', 'thunky', '.b';
        my %loose_orelse  =
            'prec', 'c=', 'assoc', 'list', 'dba', 'loose or',  'thunky', '.b';

        token infix:sym<sothen> {
            <sym> » <O(|%loose_andthen, :assoc<list>)>
        }
        token infix:sym<notsothen> {
            <sym> » <O(|%loose_andthen, :assoc<list>)>
        }
        token infix:sym<soelse> {
            <sym> » <O(|%loose_orelse, :assoc<list>, :pasttype<defor>)>
        }
    }
    my Mu $MAIN-grammar := nqp::atkey(%*LANG, 'MAIN');
    my $grammar := $MAIN-grammar.HOW.mixin($MAIN-grammar, AndSo);

    # old way
    # try nqp::bindkey(%*LANG, 'MAIN', $grammar);
    # new way
    try $*LANG.define_slang('MAIN', $grammar, $*LANG.actions);

    # Map.new;
    Map.new:
        '&infix:<sothen>'    => &infix:<sothen>,
        '&infix:<notsothen>' => &infix:<notsothen>,
        '&infix:<soelse>'    => &infix:<soelse>;
}

sub infix:<sothen>(+a) {
    # We need to be able to process `Empty` in our args, which we can get
    # when we're chained with, say, `andthen`. Since Empty disappears in normal
    # arg handling, we use nqp::p6argvmarray op to fetch the args, and then
    # emulate the `+@foo` slurpy by inspecting the list the op gave us.
    nqp::if(
      (my int $els = nqp::elems(my $args := nqp::p6argvmarray)),
      nqp::stmts(
        (my $current := nqp::atpos($args, 0)),
        nqp::if( # emulate the +@foo slurpy
          nqp::iseq_i($els, 1) && nqp::istype($current, Iterable),
          nqp::stmts(
            ($args := $current.List),
            ($current := $args[0]),
            $els = $args.elems)),
        (my int $i),
        nqp::until(
          nqp::iseq_i($els, $i = nqp::add_i($i, 1))
          || ( # if $current not true, set it to Empty and bail from the loop
            nqp::isfalse($current)
            && nqp::stmts(($current := Empty), 1)
          ),
          ($current := nqp::if(
            nqp::istype(($_ := $args[$i]), Callable),
            nqp::if(.count, $_($current), $_()),
            $_)),
          :nohandler), # do not handle control stuff in thunks
        $current), # either the last arg or Empty if any but last were undefined
      True) # We were given no args, return True
}

sub infix:<notsothen>(+a) {
    # We need to be able to process `Empty` in our args, which we can get
    # when we're chained with, say, `andthen`. Since Empty disappears in normal
    # arg handling, we use nqp::p6argvmarray op to fetch the args, and then
    # emulate the `+@foo` slurpy by inspecting the list the op gave us.
    nqp::if(
      (my int $els = nqp::elems(my $args := nqp::p6argvmarray)),
      nqp::stmts(
        (my $current := nqp::atpos($args, 0)),
        nqp::if( # emulate the +@foo slurpy
          nqp::iseq_i($els, 1) && nqp::istype($current, Iterable),
          nqp::stmts(
            ($args := $current.List),
            ($current := $args[0]),
            $els = $args.elems)),
        (my int $i),
        nqp::until(
          nqp::iseq_i($els, $i = nqp::add_i($i, 1))
          || ( # if $current is True, set it to Empty and bail from the loop
            $current && nqp::stmts(($current := Empty), 1)
          ),
          ($current := nqp::if(
            nqp::istype(($_ := $args[$i]), Callable),
            nqp::if(.count, $_($current), $_()),
            $_)),
          :nohandler), # do not handle control stuff in thunks
        $current), # either the last arg or Empty if any but last were undefined
      True) # We were given no args, return True
}

sub infix:<soelse>(+$) {
    # We need to be able to process `Empty` in our args, which we can get
    # when we're chained with, say, `andthen`. Since Empty disappears in normal
    # arg handling, we use nqp::p6argvmarray op to fetch the args, and then
    # emulate the `+@foo` slurpy by inspecting the list the op gave us.
    nqp::if(
      (my int $els = nqp::elems(my $args := nqp::p6argvmarray)),
      nqp::stmts(
        (my $current := nqp::atpos($args, 0)),
        nqp::if( # emulate the +@foo slurpy
          nqp::iseq_i($els, 1) && nqp::istype($current, Iterable),
          nqp::stmts(
            ($args := $current.List),
            ($current := $args[0]),
            $els = $args.elems)),
        (my int $i),
        nqp::until(
          nqp::iseq_i($els, $i = nqp::add_i($i, 1)) || $current,
          ($current := nqp::if(
            nqp::istype(($_ := $args[$i]), Callable),
            nqp::if(.count, $_($current), $_()),
            $_)),
          :nohandler), # do not handle control stuff in thunks
        $current),
      Nil) # We were given no args, return Nil
}
