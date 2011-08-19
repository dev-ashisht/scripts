#!/bin/bash
#
# Title:        debian-logo
# Author:       John Lawrence
#
# Description:  Print a coloured debian logo 
#

R=$(tput setaf 1; tput bold)
B=$(tput sgr0; tput bold)
N=$(tput sgr0)

echo '       '$R'_,gmi$$$$$gg.'$B
echo '     '$R',g$$$$$$$$$$$$$$$P.'$B
echo '   '$R',g$$P""'"$B       $R"'"""Y$$.".'$B
echo ' '$R\'',$$P'\'"$B              $R"'`$$$.'$B
echo ''$R'`,$$P'"$B       $R"',ggs.'"$B     $R"'`$$b:'$B
echo ' '$R'd$$'\'"$B     $R"',$P"'\'"$B   $R.$B    $R"'$$$'$B
echo ' '$R'$$P'"$B      $R"'d$'\'"$B     $R,$B    $R"'$$P'$B
echo ' '$R'$$:'"$B      $R"'$$.'"$B   $R-$B    $R"',d$$'\'$B
echo ' '$R'$$;'"$B      $R"'Y$b._'"$B   $R"'_,d$P'\'"$B        _,           _,      $R,"\''`.'$B
echo ' '$R'Y$$.'"$B    $R"'`.`"Y$$$$P"'\'"$B         "'`$$'\''         `$$'\'"     $R\`.$B  $R,'$B"
echo ' '$R'`$$b'"$B      $R"'"-.__'"$B               "'$$           $$        '$R\`\'$B
echo '  '$R'`Y$$b'"$B                        "'$$           $$         _,           _'
echo '   '$R'`Y$$.'$B'                 ,d$$$g$$  ,d$$$b.  $$,d$$$b.`$$'\'' g$$$$$b.`$$,d$$b.'
echo '     '$R'`$$b.'$B'              ,$P'\''  `$$ ,$P'\'' `Y$. $$$'\''  `$$ $$  "'\''   `$$ $$$'\'' `$$'
echo '       '$R'`Y$$b.'$B'           $$'\''    $$ $$'\''   `$$ $$'\''    $$ $$  ,ggggg$$ $$'\''   $$'
echo '         '$R'`"Y$b._'$B'        $$     $$ $$ggggg$$ $$     $$ $$ ,$P"   $$ $$    $$'
echo '             '$R'`""""'$B'      $$    ,$$ $$.       $$    ,$P $$ $$'\''   ,$$ $$    $$'
echo '                        `$g. ,$$$ `$$._ _., $$ _,g$P'\'' $$ `$b. ,$$$ $$    $$'
echo '                         `Y$$P'\''$$. `Y$$$$P'\'',$$$$P"'\''  ,$$. `Y$$P'\''$$.$$.  ,$$.'
echo $N
echo 
