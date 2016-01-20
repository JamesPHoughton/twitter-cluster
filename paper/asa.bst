%$$$ asa.bst $$$
%
% this obtained by CJP from the web - it's not necessarily Mark's most
%updated version.
%
% BibTeX `asa' style file for BibTeX version 0.99c, LaTeX version 2.09
% Place it in a file called asa.bst in the BibTeX search path.  
%(Placing it in the same directory as the LaTeX document should also work.)
% Support for named citations is provided by named.sty

% This version was made by modifying the master file made by
% Oren Patashnik (PATASHNIK@SCORE.STANFORD.EDU), and the 'named' BibTeX
% style of Peter F. Patel-Schneider.  Latest version by Mark
% J. Schervish and Michael M. Meyer

% Copyright (C) 1985, all rights reserved.
% Copying of this file is authorized only if either
% (1) you make absolutely no changes to your copy, including name, or
% (2) if you do make changes, you name it something other than 'asa.bst'.
% There are undoubtably bugs in this style.  If you make bug fixes,
% improvements, etc.  please let me know.  Our e-mail addresses are:
%    mark@stat.cmu.edu and mikem@stat.cmu.edu
%
% This style was made from 'plain.bst', 'named.bst', and 'apalike.bst', 
% with lots of tweaking to make it look like APA style, along with tips 
% from Young Ryu and Brian Reiser's modifications of 'apalike.bst'.
%
%   Citation format: 
%	      author-last-name (year)
%             author-last-name and author-last-name (year)
%             author-last-name, author-last-name, and author-last-name (year)
%             etc.
%             author-last-name et al. (year)
%             author-last-name
%             author-last-name and author-last-name
%             author-last-name, author-last-name, and author-last-name
%             author-last-name et al.
%             year
%
%   Reference format:  
%	      author-last-name, inits., (year)
%             author-last-name, inits. and author-last-name, inits. (year)
%             author-last-name, inits., author-last-name, inits., and
%                  author-last-name, inits. (year)
%             etc.
%
%   Reference list ordering: alphabetical by author or whatever passes
%    for author in the absence of one.
%
% This BibTeX style has support for abbreviated author lists and for
%    year-only citations.  This is done by having the citations
%    actually look like
%
% \citeauthoryear{full-author-info}{abbrev-author-info}{num}
%             {yearA}{year}{year-extra}{sort-string}
%
%     where num is the number of authors and
%           yearA is the year, possibly with added a, b, c, etc.
%           year  is just the year, without year-extra, and
%           year-extra is either blank or "a",  "b", etc, depending on
%                whether the year is 1997, 1997a, 1997b, etc.
%           sort-string is the string used to decide if cites
%                are by the same authors.  
%
% The LaTeX style has to be one of asa.sty, ims.sty or rss.sty (or
%    similar thing)
%
%

ENTRY
  { address
    author
    booktitle
    by
    chapter
    cjournal
    cseries
    cnumber
    cpages
    cvolume
    cyear
    department
    edition
    editor
    howpublished
    institution
    invisible
    journal
    key
%   month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    withcomment
    year
  }
  { et.al.test author.initial.test author.jr.test }
  { label extra.label sort.label }

INTEGERS { output.state before.all mid.sentence after.sentence
after.block isp isr no.punct}

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
  #4 'no.punct :=
}

STRINGS { s t ss mysort mytemp}

FUNCTION {ispunct}
{ 'ss :=			% save the string on the stack into s
 #0 'isp := 
 ss "." = { #1 'isp := } 'skip$ if$
 ss "," = { #1 'isp := } 'skip$ if$
 ss "?" = { #1 'isp := } 'skip$ if$
 ss "!" = { #1 'isp := } 'skip$ if$
 ss ";" = { #1 'isp := } 'skip$ if$
 ss ":" = { #1 'isp := } 'skip$ if$
isp}

FUNCTION {last.char}
{ 'ss :=
  ss "" * 'ss :=
  ss text.length$ 'isp :=
  #0 'isr :=
  { isr #0 = }
 
  { ss isp #1 substring$ "" =
    { #1 'isr :=
      ss isp #1 - #1 substring$ 't :=
    }
    { isp #1 + 'isp :=}
    if$
  }
  while$
  t
}

FUNCTION {shorten.quotes}
{title "" * 's :=
  "" 't :=
  title text.length$ 'isp :=
  isp isp + 'isp :=
  #0 'isr :=
  { isr #0 = }
 
  { s #1 #2 substring$ "``" =
    { t "`" * 't :=
      s #3 isp substring$ 's :=
    }
    { s #1 #2 substring$ "''" =
      { t "'" * 't :=
        s #3 isp substring$ 's :=}
      { s #1 #1 substring$ "" =
        {#1 'isr :=}
        { t s #1 #1 substring$ * 't :=
          s #2 isp substring$ 's :=
        }
        if$
      }
      if$
    }
    if$
  }
  while$
  t 
}

FUNCTION {add.comma}
{ 't :=
  output.state no.punct =
   {t }
   {t ", " *}
   if$
}

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { add.comma write$ }
    { output.state after.block =
    { add.comma write$
      newline$
      "\newblock " write$
    }
    { output.state before.all =
        'write$
        { add.comma " " * write$ }
      if$
    }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output.nonnull.colon}
{ 's :=
  output.state mid.sentence =
    { ": " * write$ }
    { output.state after.block =
    { add.comma write$
      newline$
      "\newblock " write$
    }
    { output.state before.all =
        'write$
        { add.comma " " * write$ }
      if$
    }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}
%
%FUNCTION {output.new.block}
%{ duplicate$ empty$
%    'pop$
%    {'output.nonnull
%      new.block}
%  if$
%}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
    'skip$
    { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {output.new.sentence}
{ duplicate$ empty$
    'pop$
    {'output.nonnull
      new.sentence}
  if$
}

FUNCTION {output.semicolon}
{ 's :=
  "; " * write$
  s
}

FUNCTION {output.skip.semicolon}
{ duplicate$ empty$
    'pop$
    'output.semicolon
    if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.check.colon}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull.colon
  if$
}

FUNCTION {output.year.check}
{ year empty$
     { "empty year in " cite$ * warning$ }
     { write$
        " (" year * extra.label * ")" *
        mid.sentence 'output.state :=
     }
  if$
}

FUNCTION {output.bibitem}
{ newline$

  "\bibitem[" write$
  label write$
  "]{" write$

  cite$ write$
  "}" write$
  newline$
  invisible empty$
     'skip$
     {invisible write$
      newline$}
  if$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

FUNCTION {emphasize.space}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "\/}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=               % nameptr = 1;
  s num.names$ 'numnames :=    % numnames = num.name$(s);
  numnames 'namesleft :=
    { namesleft #0 > }

    { s nameptr "{vv~}{ll}{, jj}{, f.}" format.name$ 't :=

      nameptr #1 >
        { namesleft #1 >
              { ", " * t * }
               { numnames #2 >
                    { "," * }
                    'skip$
                  if$
                  t "others" =
                        { " et~al." * } 
                       { " and " * t * }  % In biblio, author list
                      if$
                }
               if$
             }
            't
        if$
        nameptr #1 + 'nameptr :=          % nameptr += 1;
        namesleft #1 - 'namesleft :=      % namesleft =- 1;
    }
  while$
}

FUNCTION {format.names.fml}
{ 's :=
  #1 'nameptr :=               % nameptr = 1;
  s num.names$ 'numnames :=    % numnames = num.name$(s);
  numnames 'namesleft :=
    { namesleft #0 > }

    { s nameptr "{f. }{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
        { namesleft #1 >
              { ", " * t * }
               { numnames #2 >
                    { "," * }
                    'skip$
                  if$
                  t "others" =
                        { " et~al." * }
                        { " and " * t * }  % Editors in the text of biblio
                      if$
                }
               if$
             }
            't
        if$
        nameptr #1 + 'nameptr :=          % nameptr += 1;
        namesleft #1 - 'namesleft :=      % namesleft =- 1;
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

%FUNCTION {format.key}
%{ empty$
%    { key field.or.null }
%    { "" }
%  if$
%}

FUNCTION {format.editors.fml}
{ editor empty$
    { "" }
    { 
      editor num.names$ #1 >
    { "eds. " * }
    { "ed. " * }
      if$
    editor format.names.fml
    }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { 
      editor num.names$ #1 >
    { "eds. " * }
    { "ed. " * }
      if$
      editor format.names
    }
  if$
}

FUNCTION {format.editors.dot}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
    { " (eds.)" * }
%    { ", eds." * }
    { " (ed.)" * }
%    { ", ed." * }
      if$
    }
  if$
}

% Note that the APA style requres case changes
% in article titles. The following does not
% change cases. If you perfer it, uncomment the
% following and comment out the above.

FUNCTION {format.title}
{ shorten.quotes 's :=
  s last.char ispunct
   'skip$
   {s "," * 's :=}
  if$
  by missing$
    {"``" s * }
    {"Comment on ``" s *}
  if$
  withcomment missing$
    {by missing$
       {"''" *}
       {"'' by " * by format.names.fml * "," *}
     if$
     }
    {"'' (with comments)," *}
if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
    { t #1 #2 substring$ "--" = not
        { "--" *
          t #2 global.max$ substring$ 't :=
        }
        {   { t #1 #1 substring$ "-" = }
        { "-" *
          t #2 global.max$ substring$ 't :=
        }
          while$
        }
      if$
    }
    { t #1 #1 substring$ *
      t #2 global.max$ substring$ 't :=
    }
      if$
    }
  while$
}

FUNCTION {format.btitle}
{ edition empty$
  { title emphasize }
  { title empty$
    { "there's an edition but no title in " cite$ * warning$}
    { "{\em " title * "\/} (" * edition * " ed.)" *}
    if$
  }
  if$
}

FUNCTION {format.emphasize.booktitle}
{ edition empty$
  { booktitle emphasize }
  { booktitle empty$
    { booktitle emphasize }
    { "{\em " booktitle * "\/} (" * edition * " ed.)" * }
    if$
  }
  if$
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "volume" volume tie.or.space.connect 
      series empty$
        'skip$
        { " of " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
	    { series field.or.null }    % if number
	    { output.state mid.sentence =
	        { "number" }
	        { "Number" }
	      if$
	      number tie.or.space.connect
	      series empty$
	        { "there's a number but no series in " cite$ * warning$ }
	        { " in " * series * }
	      if$
	    }				% else number
      if$
    }					%if volume
    { "" }				% else volume
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
        { edition "l" change.case$ " edition" * }
        { edition "t" change.case$ " edition" * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
    { #1 'multiresult := }
    { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
  { "" }
  { pages multi.page.check
%    { "pages" pages n.dashify tie.or.space.connect }
%    { "page" pages tie.or.space.connect }
	{ "pp.\" pages n.dashify tie.or.space.connect }
	{ "pp.\" pages tie.or.space.connect }
    if$
  }
  if$
}

% By Young (and Spencer)
FUNCTION {format.vol.num.pages}
{ number empty$
    { volume empty$
       { "" }
       { volume }
      if$
    }
    { volume empty$
       {"there's a number but no volume in " cite$ * warning$ }
       { volume "(" * number * ")"  * }
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
       { " " * pages n.dashify * }
      { ", " * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { " chapter" }
        { type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
  { "" }
  { editor empty$
    { "in " format.emphasize.booktitle * }
    { "in " format.emphasize.booktitle * ", " * format.editors.fml *  }
    if$
  }
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ "In"
  "\cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
    'skip$
%    { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
    { editor #2 "{f. }{vv }{ll}{ jj}" format.name$ "others" =
        { " et~al." * }
        { ", and " * editor #2 "{vv~}{ll}" format.name$ * }
      if$
    }
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "In "
    }
    { "Volume" volume tie.or.space.connect
      " of " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
    { series empty$
        { "need editor, key, or series for " cite$ * " to crossref " *
          crossref * warning$
          "" *
        }
        { "{\em " * series * "\/}" * }
      if$
    }
    { key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ "In"
  " \cite{" * crossref * "}" *
}

FUNCTION {isrepeat}
{ sort.label 'mytemp :=
   mytemp mysort =
	{pop$ "{\rule[0.5ex]{6ex}{.05em}\,}"} % pop stack, write rule
	{}                                    % author is on stack, leave
   if$
   mytemp 'mysort :=}

FUNCTION {format.cvol.cnum.cpages}
{ cnumber empty$
    { cvolume empty$
       { "" }
       { cvolume }
      if$
    }
    { cvolume empty$
      'skip$
%       {"there's a cnumber but no cvolume in " cite$ * warning$ }
       { cvolume "(" * cnumber * ")"  * }
      if$
    }
  if$
  cpages empty$
    'skip$
    { duplicate$ empty$
       { " " * cpages n.dashify * }
       { ", " * cpages n.dashify * }
    if$
    }
  if$
}

FUNCTION {format.correction}
{ cyear missing$
    'skip$
    { "Corrigenda (" cyear * ")" * output.skip.semicolon
     cjournal emphasize output
     cseries missing$
        'skip$
        { ", " * cseries *}
     if$
     format.cvol.cnum.cpages output
     new.block
    }
  if$
}

FUNCTION {article}
{ output.bibitem
  format.authors 
  isrepeat
  "author" output.check
%  author format.key output          % added
%   author output
  output.year.check                 % added
  new.block
  format.title 
  "title" output.check
  new.block
  no.punct 'output.state :=
  crossref missing$
    { journal emphasize "journal" output.check
      series missing$
	    'skip$
	    { ", Ser. " * series * }
      if$
      format.vol.num.pages output
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  format.correction 
  new.block
  note output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { editor empty$
      { format.btitle
        "title" output.check }
      { format.editors.dot 
	    isrepeat
	    "author and editor" output.check }
    if$
    }
    { format.authors 
	  isrepeat
	  output.nonnull
      crossref missing$
    	{ "author and editor" editor either.or.check }
    	'skip$
      if$
    }
  if$
  output.year.check       % added
  new.block
  author empty$
  editor empty$ 
  and
    'skip$
      { format.btitle 
       "title" output.check
       title 's :=
       s last.char ispunct
         {no.punct 'output.state :=}
         'skip$
       if$}
  if$
  crossref missing$
%    { format.bvolume output.new.block
    { format.bvolume output
      format.number.series output.new.sentence
      address output
      publisher "publisher" output.check.colon
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
%  format.edition output
  new.block
  note output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  author empty$
    { format.editors.dot 
	  isrepeat
	  "author and editor" output.check }
    { format.authors 
	  isrepeat
	  output.nonnull
      crossref missing$
    	{ "author and editor" editor either.or.check }
    	'skip$
      if$
    }
  if$
  output.year.check                 % added
  new.block
  format.title 
  "title" output.check
  new.block
  no.punct 'output.state :=
  howpublished output
  address output
  new.block
  note output.skip.semicolon
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors.dot 
      isrepeat
      "author and editor" output.check 
    }
    { format.authors 
      isrepeat 
      output.nonnull
      crossref missing$
    { "author and editor" editor either.or.check }
    'skip$
      if$
    }
  if$
  output.year.check                 % added
  new.block
  format.btitle 
  "title" output.check
  crossref missing$
    { format.bvolume output
      format.chapter.pages 
      "chapter and pages" output.check
      new.block
      format.number.series output
      new.sentence
      address output
      publisher 
      "publisher" output.check.colon
    }
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
%  format.edition output
  new.block
  format.correction 
  new.block
  note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors
  isrepeat
  "author" output.check
  output.year.check              % added
  new.block
  format.title 
  "title" output.check
  new.block
  no.punct 'output.state :=
  crossref missing$
  { format.in.ed.booktitle
%    "booktitle" output.check.colon
    "booktitle" output.check
    volume empty$
	'skip$
	{format.bvolume output}
    if$
    format.number.series output
    new.sentence
    address output
    publisher "publisher" output.check.colon
    format.chapter.pages  output % special.output
  }
  { format.incoll.inproc.crossref 
	output.nonnull
    format.chapter.pages output
  }
  if$
  new.block
  format.correction 
  new.block
  note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors 
  isrepeat
  "author" output.check
%  author output
%  author format.key output            % added
  output.year.check                   % added
  new.block
  format.title 
  "title" output.check
  new.block
  no.punct 'output.state :=
  crossref missing$
    { format.in.ed.booktitle 
	  "booktitle" output.check
      format.bvolume output
      format.number.series output
      new.sentence
      organization emphasize output
      address output
      publisher empty$
        'skip$
        { publisher output.nonnull.colon}
      if$
      format.pages output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  format.correction 
  new.block
  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  author empty$
    {format.btitle
     "title" output.check}
    { format.authors 
      isrepeat
      output}
  if$
  output.year.check                 % added
  new.block
  author empty$
     'skip$
    {format.btitle 
     "title" output.check}
  if$
  organization address new.block.checkb
  address output
  organization "organization" output.check.colon
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors 
  isrepeat
  "author" output.check
  output.year.check                 % added
  new.block
  format.title 
  "title" output.check
  new.block
  no.punct 'output.state :=
  "unpublished Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  department output
  new.block
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors 
  isrepeat
  output
  output.year.check                   % added
  title howpublished new.block.checkb
  format.title output
  new.block
  no.punct 'output.state :=
  howpublished output
  new.block
  note output
  fin.entry
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors 
  isrepeat
  "author" output.check
  output.year.check                   % added
  new.block
  format.btitle 
  "title" output.check
  new.block
  "unpublished Ph.D. dissertation" format.thesis.type output.nonnull
  school "school" output.check
  department output
  new.block
  note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors.dot 
      isrepeat 
      output.nonnull }
  if$
  output.year.check                    % added
  new.block
  format.btitle 
  "title" output.check
  format.bvolume output
  format.number.series output
  organization output
  address output
      publisher empty$
        'skip$
        { publisher output.nonnull.colon}
      if$
  new.block
  note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors 
  isrepeat
  "author" output.check
  output.year.check                    % added
  new.block
  format.title 
  "title" output.check
  new.block
  no.punct 'output.state :=
  format.tr.number output.nonnull
  institution 
  "institution" output.check
  department output
  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors 
  isrepeat
  "author" output.check
  output.year.check                      % added
  new.block
  format.title 
  "title" output.check
  new.block
  no.punct 'output.state :=
  " unpublished manuscript" output.nonnull
  new.block
  note output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {stat} {"Dept. of Statistics"}

MACRO {cmu}  {"Carnegie Mellon University"}

MACRO {ny}   {"New York"}

MACRO {ams} {"The Annals of Mathematical Statistics"}

MACRO {amstat} {"The American Statistician"}

MACRO {amath} {"Annals of Mathematics"}

MACRO {advap} {"Advances in Applied Probability"}

MACRO {annals} {"The Annals of Statistics"}

MACRO {anneug} {"Annals of Eugenics"}

MACRO {annalp} {"The Annals of Probability"}

MACRO {annalap} {"The Annals of Applied Probability"}

MACRO {appstat} {"Applied Statistics"}

MACRO {ausjstat} {"Australian Journal of Statistics"}

MACRO {bioc} {"Biometrics"}

MACRO {bioj} {"Biometrical Journal"}

MACRO {biok} {"Biometrika"}

MACRO {bjmsp} {"British Journal of Mathematical and Statistical Psychology"}

MACRO {bjsp} {"British Journal of Statistical Psychology"}

MACRO {chance} {"Chance"}

MACRO {cjs} {"The Canadian Journal of Statistics"}

MACRO {compstat} {"Computational Statistics"}

MACRO {compstda} {"Computational Statistics and Data Analysis"}

MACRO {commstm} {"Communications in Statistics, Part A --- Theory and Methods"}

MACRO {comms} {"Communications in Statistics"}

MACRO {commscs} {"Communications in Statistics, Part B --- Computation and Simulation"}

MACRO {isr} {"International Statistical Review"}

MACRO{jap} {"Journal of Applied Probability"}

MACRO{jtp} {"Journal of Theoretical Probability"}

MACRO {jasa} {"Journal of the American Statistical Association"}

MACRO {jcgs} {"Journal of Computational and Graphical Statistics"}

MACRO {jes} {"Journal of Educational Statistics"}

MACRO {jma} {"Journal of Multivariate Analysis"}

MACRO {jos} {"Journal of Official Statistics"}

MACRO {jrss} {"Journal of the Royal Statistical Society"}

MACRO {jscs} {"Journal of Statistical Computation and Simulation"}

MACRO {jspi} {"Journal of Statistical Planning and Inference"}

MACRO {juric} {"Jurimetrics"}

MACRO {mansci} {"Management Science"}

MACRO {psyka} {"Psychometrika"}

MACRO {ptrf} {"Probability Theory and Related Fields"}

MACRO {sankhya} {"Sankhy\={a}"}

MACRO {scandjs} {"Scandinavian Journal of Statistics: Theory and Applications"}

MACRO {siamjssc} {"SIAM Journal of Scientific and Statistical Computing"}

MACRO {sasj} {"South African Statistical Journal"}

MACRO {statsin} {"Statistica Sinica"}

MACRO {spl} {"Statistics and Probability Letters"}

MACRO {statsci} {"Statistical Science"}

MACRO {statmed} {"Statistics in Medicine"}

MACRO {survmeth} {"Survey Methodology"}

MACRO {tech} {"Technometrics"}

MACRO {toap} {"to appear"}

MACRO {tstat} {"The Statistician"}

MACRO {tpaa} {"Theory of Probability and its Applications"}

MACRO {zw} {"Zeitschrift f\um{u}r Wahrscheinlichkeitstheorie und Verwandte Gebiete"}

MACRO {wiley} {"John Wiley"}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

INTEGERS { fullptr numfull fullsleft }

STRINGS { u1 u2 }


FUNCTION {my.full.label}
{ 
% Initialize 'u1','u2','s'.
  "" 'u1 :=                                       
  "" 'u2 :=                     
  's :=                      

% Initialize 'fullptr','numfull','fullsleft'.
  #1 'fullptr :=                         
  s num.names$ 'numfull :=   
  numfull 'fullsleft :=          

% enter the while loop which generates the first-citation information.
% while we have names left, 
%     format the next name
%   if this is the next-to-last name, tack the ampersand on the end
%   else if this isn't the last name, tack the comma on the end.
%   concatenate the next name onto the first-citation string.
%   update the counters.

%MMM
%  numfull #5 >
%     { s fullptr "{vv~}{ll}" format.name$ 'u1 :=
%       u1 " et~al." * 'u2 := }
%{
  { fullsleft #0 > }
  {  author.initial.test fullptr =
     {s fullptr "{f. }{vv~}{ll}" format.name$ 'u1 :=}  %Need Initials
     { author.jr.test fullptr =
        {s fullptr "{vv~}{ll}{ jj}" format.name$ 'u1 :=}  %Need Jr
        {s fullptr "{vv~}{ll}" format.name$ 'u1 :=}  %Don't Need Initials or Jr
      if$}
   if$


      numfull #2 =
	{ fullsleft #2 = 
	       { u1 " and " * 'u1 := }   % Bibitem first (long) cite form.
	       'skip$
	if$
	}
       { fullsleft #2 =
       { u1 ", and " * 'u1 := }
	      { fullsleft #2 > 
	           { u1 ", " * 'u1 := }
	           'skip$
	         if$
	        } 
	    if$ }
	if$
     u2 u1 * 'u2 :=
     fullptr #1 + 'fullptr :=         
     fullsleft #1 - 'fullsleft :=  
  }
  while$
% }   if$

% push 'u2' onto the stack -- our first-citation information.
  u2        
}

FUNCTION {format.lab.names}
{ 's :=          
  author.initial.test #1 =
     {s #1 "{f. }{vv~}{ll}" format.name$}     % Get first name on stack, with initials
     {  author.jr.test #1 =
         {s #1 "{f. }{vv~}{ jj}" format.name$}     % Get first name on stack, with Jr
	 {s #1 "{vv~}{ll}" format.name$}     % Get first name on stack, without initials/Jr
       if$}
   if$
  s num.names$ duplicate$           % Count number of names, duplicate
  #2 >                                
     { et.al.test #0 =
        { pop$ " et~al." * } % In bibitem short form (et.al==0)
        {pop$ pop$ s my.full.label }              %(et.al==1)
      if$ }            
     { #2 <
          'skip$
          { s #2 "{f. }{vv }{ll}{ jj}" format.name$ "others" =  
              % If bib file is "and others", then put in et. al.
                { "et~al. " * }
               {   author.initial.test #2 =
		    {" and " * s #2 "{f. }{vv~}{ll}" format.name$ * }
		    { author.jr.test #2 =
 		        {" and " * s #2 "{f. }{vv~}{ jj}" format.name$ * }
                        {" and " * s #2 "{vv~}{ll}" format.name$ * }
                      if$}
                   if$
               } %Bibitem, short
             if$
            }
       if$
     }
  if$
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
          { cite$ #1 #3 substring$ }
         'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.label}
{ editor empty$
    { key empty$
          { cite$ #1 #3 substring$ }
          'key
        if$
     }
     { editor format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
          { key empty$
               { cite$ #1 #3 substring$ }
             'key
           if$
         }
          { editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

%MMM New function %%
FUNCTION {author.editor.key.my.full.label}
{ author empty$
    { editor empty$
          { key empty$
               { cite$ #1 #3 substring$ }
             'key
           if$
         }
          { editor my.full.label }
      if$
    }
    { author my.full.label }
  if$
}

FUNCTION {calc.label.editor}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
          'editor.key.label
          'author.key.label
        if$
    }
  if$
  duplicate$    
%  editor my.full.label  % generate the first-citation information.
  editor missing$
  {key}
  {editor my.full.label}  % generate the first-citation information.
  if$
  "\protect\citeauthoryear{" swap$ * "}{" * swap$ * "}{" *
   numfull int.to.str$ * "}{" *
  year field.or.null purify$ #-1 #4 substring$ *  
  'label :=
  year field.or.null purify$ #-1 #4 substring$ *
  sortify 'sort.label :=
}


FUNCTION {calc.label}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
          'editor.key.label
          'author.key.label
        if$
    }
  if$
  duplicate$    
  author my.full.label  % generate the first-citation information.
  "\protect\citeauthoryear{" swap$ * "}{" * swap$ * "}{" *
   numfull int.to.str$ * "}{" *
  year field.or.null purify$ #-1 #4 substring$ *  
  'label :=
  year field.or.null purify$ #-1 #4 substring$ *
  sortify 'sort.label :=
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
          { "   " * }
         'skip$
      if$
%MMM  "ff" below was previously "f".  We want full name, please.
      s nameptr "{vv{ } }{ll{ }}{  f{ }}{  jj{ }}" format.name$ 't :=
      nameptr numnames = t "others" = and
          { "et al" * }
          { t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
          { "to sort, need author or key in " cite$ * warning$
              ""
         }
         { key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.sort}
{ editor empty$
    { key empty$
         { "to sort, need editor or key in " cite$ * warning$
           ""
         }
         { key sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
         { key empty$
             { "to sort, need author, editor, or key in " cite$ * warning$
               ""
             }
             { key sortify }
           if$
         }
         { editor sort.format.names }
      if$
   }
   { author sort.format.names }
  if$
}

FUNCTION {presort}
{ author empty$
     { calc.label.editor }
     { calc.label }
     if$
      label sortify
      "    "
      *
      type$ "book" =
      type$ "inbook" =
      or
	'author.editor.sort
	{ type$ "proceedings" =
	      'editor.sort
	      'author.sort
	  if$
	}
      if$
      #1 entry.max$ substring$        % added for newapa
      'sort.label :=                  % added for newapa
      sort.label                      % added for newapa
      *
      "    "
      *
      title field.or.null
      sort.format.title
      *
      #1 entry.max$ substring$
      'sort.key$ :=
}


STRINGS { last.sort next.extra}

INTEGERS { last.extra.num }

FUNCTION {init.et.al} {
  #0 'et.al.test :=
  #0 'author.initial.test :=
  #0 'author.jr.test :=
}

FUNCTION {initialize.extra.label.stuff}
{ #0 int.to.chr$ 'last.sort :=
  "" 'next.extra :=
  #0 'last.extra.num :=
}


ITERATE {init.et.al}

EXECUTE {initialize.extra.label.stuff}

ITERATE {presort}


SORT             % by label, sort.label, title --- for final label calculation

%T%FUNCTION {printit}
%T%{ "P1LABEL--" label * "---" * sort.label * "---" * title * write$ newline$
%T%  "P1KEY---" sort.key$ * write$ newline$}
%T%ITERATE{printit}


%MMM  Comparision used to be on label.  I changed to have it be on sort.label
FUNCTION {forward.pass}
{ %last.label label =
last.sort sort.label year * =
     { last.extra.num #1 + 'last.extra.num :=
       last.extra.num int.to.chr$ 'extra.label :=
     }
     { "a" chr.to.int$ 'last.extra.num :=
       "" 'extra.label :=
       sort.label year * 'last.sort :=
    }
  if$
}

%T%FUNCTION {hehe}
%T% { sort.label year * write$ newline$ label write$ newline$}
%T%ITERATE {hehe}


FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
     'skip$
  if$
  label extra.label * "}{" * year * "}{" * extra.label * "}" * 
%MMM Next line added to output the sort string.
           "{" * sort.label * "}" * 
             'label :=   
  extra.label 'next.extra :=
}


ITERATE {forward.pass}

%T%FUNCTION {hoho}
%T% { sort.label write$ newline$ extra.label write$ newline$}
%T%ITERATE {hoho}

REVERSE {reverse.pass}


%%% MMM Hacks..........
%% Idea.  First sort on OTHER2 and year. If et~al. would introduce ambiguity
% (figure that out by comparing sort.label and year)
%% Next sort on OTHER and year.  If there would be an ambiguity, write
% out an a warning message, telling the author to use \nocite and do
% it by hand.

FUNCTION {reset} { "" 'last.sort := "" 'mytemp :=
                   "" 'ss := "" 't :=}


EXECUTE {reset}

FUNCTION {author.year.sort.order}
{
 author.editor.key.label year * extra.label * 'sort.key$ :=
}

ITERATE {author.year.sort.order}

SORT	     % By, author.editor.key.label and year

% Following checks if the short form of citation would lead to
% ambiguity.  If yes, then et.al.test becomes 1.  If the form
% A. G. Author et. al would solve the ambiguity, then et.al.test
% becomes 0, but author.initial.test is 1.
FUNCTION {et.al.check}
{ author empty$
   { editor empty$
	 { key 'ss := }
	 { editor 'ss := }
     if$
   }
   { author 'ss := }
  if$

et.al.test #1 =
  {}
  { last.sort sort.key$ =
    { mytemp sort.label =
       { #0 'et.al.test := }
       { ss #1 "{f. }{vv~}{ll}" format.name$
             t #1 "{f. }{vv~}{ll}" format.name$ =
          {#1 'et.al.test := }
          {#0 'et.al.test :=
           #1 'author.initial.test := }
         if$
       }
     if$
    }
    { #0 'et.al.test := }
    if$}
if$
ss 't :=

%T%"Key--" sort.key$ * warning$
%T%"Label--" sort.label * warning$
%T%"Mytemp--" mytemp * warning$
%T%"Last sort--" last.sort * warning$
%T%"Test-- " et.al.test int.to.str$ * warning$
sort.key$ 'last.sort :=
sort.label 'mytemp :=
}

EXECUTE {reset}

ITERATE {et.al.check}

EXECUTE {reset}

REVERSE {et.al.check}

%T%FUNCTION {printit2}
%T%{ "P2LABEL--" sort.label * "---" * year * "---" * title * write$ newline$
%T%  "P2KEY---" sort.key$ * write$ newline$
%T%  "P2OTHER--" author.editor.key.my.full.label * write$ newline$ 
%T%  "P2OTHER2--" author.editor.key.label * write$ newline$ 
%T%}
%T%ITERATE{printit2}

%AND NOW REDO THE LABELS.
%% This may not be necessary just here (it is eventually).

%T%ITERATE {presort}

%T%ITERATE {forward.pass}

%T%REVERSE {reverse.pass}


FUNCTION {author.year.sort.order.full}
{
 author.editor.key.my.full.label year * extra.label * 'sort.key$ :=
}

ITERATE {author.year.sort.order.full}

SORT	     % By, author.editor.key.my.full.label and year

% Following checks if the long form of citation would lead to
% ambiguity.  If yes, then print a warning.
FUNCTION {full.check}
{ 
author empty$
 { editor empty$
       { key 'ss := }
       { editor 'ss := }
   if$
 }
 { author 'ss := }
if$

  last.sort sort.key$ =
  { mytemp sort.label =
     { }
     { 
%T%       "References " s * " and " * cite$ * 
%T%       " are different but would appear the same " *
%T%       " Use \nocite and build the reference by hand" *
%T%       warning$
%T%	"AUTHOR---" author * warning$
%T%        t warning$
	ss num.names$ 'namesleft :=   %Init number of names
	#0 'author.initial.test :=
	#0 'author.jr.test :=
       % while namesleft is > 0, update author.initial.test to check 
       % which author name to format.  If they format differently, we
       % have  what we want.  Otherwise, continue.
        { namesleft #0 >}
        {author.initial.test #1 + 'author.initial.test :=
         author.jr.test #1 + 'author.jr.test :=
	   t author.initial.test "{vv{ } }{ll{ }}{  f{ }}" format.name$
	       ss author.initial.test "{vv{ } }{ll{ }}{  f{ }}" format.name$ =
             {}
             { #0 'author.jr.test :=
               #0 'namesleft :=}
           if$
	   t author.jr.test "{vv{ } }{ll{ }}{  jj{ }}" format.name$
	       ss author.jr.test "{vv{ } }{ll{ }}{  jj{ }}" format.name$ =
             {}
             { #0 'author.initial.test :=
               #0 'namesleft :=}
           if$

}
	while$
}
   if$
  }
  { }
 if$
%T%"Key--" sort.key$ * warning$
%T%"Lab--" sort.label * warning$
%T%"Author2--" ss * warning$
sort.key$ 'last.sort :=
sort.label 'mytemp :=
cite$ 's :=
ss 't :=
}


EXECUTE {reset}

ITERATE {full.check}

EXECUTE {reset}

REVERSE {full.check}

%% This may not be necessary just here (it is eventually).
ITERATE {presort}

ITERATE {forward.pass}

REVERSE {reverse.pass}

%%% MMM Hacks..........

FUNCTION {bib.sort.order}
{ sort.label
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {bib.sort.order}

SORT             % by sort.label, year, title --- giving final bib. order.



%T%ITERATE{printit2}

FUNCTION {begin.bib}

{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{}" write$ newline$
}


EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}


