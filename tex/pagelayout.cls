%%
%% Copyright (c) 2022-2023 by Friedemann Bartels
%%
%% This file may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either
%% version 1.3c of this license or (at your option) any later
%% version.  The latest version of this license is in:
%%
%%    http://www.latex-project.org/lppl.txt
%%
%% and version 1.3c or later is part of all distributions of
%% LaTeX version 2008/05/04 or later.
%%

\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{pagelayout}[2023/12/21 Layout graphic rich documents]
\def\pagelayoutversion{1.0.5}

% packages
\RequirePackage{pgfopts}
\RequirePackage{tikz}
\RequirePackage{tcolorbox}
\tcbuselibrary{magazine}

% helper
\def\pal@emptystring{}
\def\pal@striplastexclamationmark#1{\pal@striplastexclamationmarka{#1}#1\end !\end\eend}
\def\pal@striplastexclamationmarka#1#2!\end#3\eend{\ifx\end#3\end#1\else#2\fi}
\def\pal@instring#1#2{TT\fi\begingroup\edef\pal@x{\endgroup\noexpand\in@{#1}{#2}}\pal@x\ifin@}
\def\pal@dimentonumber#1{\strip@pt\dimexpr #1*65536/\number\dimexpr 1\unitlength}

% ifs
\newif\ifpal@leftpage
\newif\ifpal@rightpage

\newif\ifpal@twoside
\newif\ifpal@fanfold
\newif\ifpal@cover
\newif\ifpal@beginleft
\newif\ifpal@beginright
\newif\ifpal@grid
\newif\ifpal@preflight
\newif\ifpal@graphpaper
\newif\ifpal@placeholder
\newif\ifpal@safezone
\newif\ifpal@cuttingmarks
\newif\ifpal@fillpages
\newif\ifpal@frontcover
\newif\ifpal@backcover

\newif\ifpal@hascover
\newif\ifpal@haspages
\newif\ifpal@isdoublepage
\newif\ifpal@ispage
\newif\ifpal@isemptypage
\newif\ifpal@haslastemptypage
\newif\ifpal@hasoddnumberofpages
\newif\ifpal@cuttingmarksvisible
\newif\ifpal@isfanfoldopen
\newif\ifpal@isinitgrid
\newif\ifpal@haspagegraphic
\newif\ifpal@isperformancemode
\newif\ifpal@isturbomode
\newif\ifpal@isbatchmode
\newif\ifpal@ismaskrequired
\newif\ifpal@optimize
\newif\ifpal@import
\newif\ifpal@isluatex

% dimensions
\newdimen\pal@null\pal@null=0pt
\newdimen\pal@undefdim\pal@undefdim=-1sp

\ifdefined\pagewidth\pal@isluatextrue\else\newdimen\pagewidth\newdimen\pageheight\fi
\newdimen\bleed\newdimen\outerbleed\newdimen\innerbleed\newdimen\topbleed\newdimen\bottombleed
\newdimen\safetymargin\newdimen\topsafetymargin\newdimen\bottomsafetymargin\newdimen\innersafetymargin\newdimen\outersafetymargin
\newdimen\innermargin\newdimen\bottommargin\newdimen\outermargin\newdimen\margin
\newdimen\gutter\newdimen\spinewidth\newdimen\bindingoffset
\newdimen\coverwidth\newdimen\coverheight
\newdimen\coverbleed\newdimen\coverouterbleed\newdimen\coverinnerbleed\newdimen\covertopbleed\newdimen\coverbottombleed
\newdimen\coversafetymargin\newdimen\covertopsafetymargin\newdimen\coverbottomsafetymargin\newdimen\coverinnersafetymargin\newdimen\coveroutersafetymargin

\newdimen\pal@pagewidth\newdimen\pal@pageheight
\newdimen\pal@outerbleed\newdimen\pal@innerbleed\newdimen\pal@topbleed\newdimen\pal@bottombleed
\newdimen\pal@topsafetymargin\newdimen\pal@bottomsafetymargin\newdimen\pal@innersafetymargin\newdimen\pal@outersafetymargin
\newdimen\pal@topmargin\newdimen\pal@topmargintmp\newdimen\pal@innermargin\newdimen\pal@bottommargin\newdimen\pal@outermargin
\newdimen\pal@gutter
\newdimen\pal@x\newdimen\pal@y\newdimen\pal@xx\newdimen\pal@yy\newdimen\width\newdimen\height\newdimen\x\newdimen\y
\newdimen\pal@gridoffsethorizontal\newdimen\pal@gridoffsetvertical\newdimen\pal@gridoffsethorizontaln\newdimen\pal@gridoffsetverticaln
\newdimen\pal@graphpaperx\newdimen\pal@graphpapery\newdimen\pal@graphpaperoffset\newdimen\pal@graphpapersnap

% interface
\newcommand\ifleftpage[1]{\ifpal@leftpage#1\fi}
\newcommand\ifrightpage[1]{\ifpal@rightpage#1\fi}
\newcommand\ifspine[1]{\ifpal@cover#1\fi}
\def\twoside{\pal@twosidetrue}
\def\fanfold{\pal@fanfoldtrue}
\def\cover{\pal@covertrue}
\def\beginleft{\pal@beginlefttrue}
\def\beginright{\pal@beginrighttrue}
\def\grid{\pal@gridtrue}\def\nogrid{\pal@gridfalse}
\def\preflight{\pal@preflighttrue}\def\nopreflight{\pal@preflightfalse}
\def\graphpaper{\pal@graphpapertrue}\def\nographpaper{\pal@graphpaperfalse}
\def\placeholders{\pal@placeholdertrue}\def\noplaceholders{\pal@placeholderfalse}
\def\safezone{\pal@safezonetrue}\def\nosafezone{\pal@safezonefalse}
\def\cuttingmarks{\pal@cuttingmarkstrue}\def\nocuttingmarks{\pal@cuttingmarksfalse}
\def\fillpages{\pal@fillpagestrue}\def\nofillpages{\pal@fillpagesfalse}
\newcommand\optimize[1][]{\pal@optimizetrue\pgfkeys{optimize,#1}}
\def\density#1{\def\pal@density{#1}}
\def\quality#1{\def\pal@quality{#1}}
\def\import{\pal@importtrue}

\def\setgraphpaper#1{
  \def\pal@graphpaperconfig{#1}
  \foreach \pal@graphpaperconfigitem in \pal@graphpaperconfig {
    \global\pal@graphpapersnap=\pal@graphpaperconfigitem
  }
}
\setgraphpaper{1mm,5mm}

\def\pal@pagecolormodel{}
\def\pal@pagecolor{}
\renewcommand\pagecolor[2][]{
  \ifpal@ispage
    \def\pal@pagecolormodel{#1}
    \def\pal@pagecolor{#2}
  \else
    \global\def\pal@pagecolormodel{#1}
    \global\def\pal@pagecolor{#2}
  \fi
}
\newcommand\setpagecolor[2][]{\pagecolor[#1]{#2}}
\def\nopagecolor{\pagecolor{}}

\def\pal@current@color{black}
\let\pal@originalcolor\color
\def\color#1{\ifpal@ispage\ifx\pal@current@color#1\else\def\pal@current@color{#1}\pal@originalcolor{#1}\fi\else\def\paloptions@color{#1}\fi}
\def\setcolor#1{\color{#1}}

\let\pal@originalpagenumbering\pagenumbering
\newif\ifpal@pagenumberinghaschanged
\renewcommand\pagenumbering[1]{\pal@pagenumberinghaschangedtrue\pal@originalpagenumbering{#1}}

% options
\def\pal@density{300}
\def\pal@downsamplethreshold{120}
\def\pal@quality{}
\def\pal@unsharp{2x1}
\pgfkeysdef{/optimize/downsample threshold}{
  \pgfmathqparse{#1pt*100pt}
  \pgfmathround{\pgfmathresult}
  \pgfmathint{\pgfmathresult}
  \edef\pal@downsamplethreshold{\pgfmathresult}
}
\pgfkeys{
  /optimize/.is family,
  /optimize,
  density/.store in=\pal@density,
  quality/.store in=\pal@quality,
  unsharp/.store in=\pal@unsharp,
}
\pgfkeys{
  /pal/.cd,
  % page dimensions
  pagewidth/.code={\setlength{\pagewidth}{#1}},pagewidth=210mm,
  pageheight/.code={\setlength{\pageheight}{#1}},pageheight=297mm,
  bleed/.code={\setlength{\bleed}{#1}},bleed=0pt,
  outerbleed/.code={\setlength{\outerbleed}{#1}},outerbleed=\pal@undefdim,
  innerbleed/.code={\setlength{\innerbleed}{#1}},innerbleed=\pal@undefdim,
  topbleed/.code={\setlength{\topbleed}{#1}},topbleed=\pal@undefdim,
  bottombleed/.code={\setlength{\bottombleed}{#1}},bottombleed=\pal@undefdim,
  safetymargin/.code={\setlength{\safetymargin}{#1}},safetymargin=0pt,
  outersafetymargin/.code={\setlength{\outersafetymargin}{#1}},outersafetymargin=\pal@undefdim,
  innersafetymargin/.code={\setlength{\innersafetymargin}{#1}},innersafetymargin=\pal@undefdim,
  topsafetymargin/.code={\setlength{\topsafetymargin}{#1}},topsafetymargin=\pal@undefdim,
  bottomsafetymargin/.code={\setlength{\bottomsafetymargin}{#1}},bottomsafetymargin=\pal@undefdim,
  % cover dimensions
  coverwidth/.code={\setlength{\coverwidth}{#1}},coverwidth=\pal@undefdim,
  coverheight/.code={\setlength{\coverheight}{#1}},coverheight=\pal@undefdim,
  coverbleed/.code={\setlength{\coverbleed}{#1}},coverbleed=\pal@undefdim,
  coverouterbleed/.code={\setlength{\coverouterbleed}{#1}},coverouterbleed=\pal@undefdim,
  coverinnerbleed/.code={\setlength{\coverinnerbleed}{#1}},coverinnerbleed=\pal@undefdim,
  covertopbleed/.code={\setlength{\covertopbleed}{#1}},covertopbleed=\pal@undefdim,
  coverbottombleed/.code={\setlength{\coverbottombleed}{#1}},coverbottombleed=\pal@undefdim,
  coversafetymargin/.code={\setlength{\coversafetymargin}{#1}},coversafetymargin=\pal@undefdim,
  coveroutersafetymargin/.code={\setlength{\coveroutersafetymargin}{#1}},coveroutersafetymargin=\pal@undefdim,
  coverinnersafetymargin/.code={\setlength{\coverinnersafetymargin}{#1}},coverinnersafetymargin=\pal@undefdim,
  covertopsafetymargin/.code={\setlength{\covertopsafetymargin}{#1}},covertopsafetymargin=\pal@undefdim,
  coverbottomsafetymargin/.code={\setlength{\coverbottomsafetymargin}{#1}},coverbottomsafetymargin=\pal@undefdim,
  spinewidth/.code={\setlength{\spinewidth}{#1}},spinewidth=3mm,
  bindingoffset/.code={\setlength{\bindingoffset}{#1}},bindingoffset=0pt,
  % grid dimensions
  margin/.code={\setlength{\margin}{#1}},margin=20mm,
  outermargin/.code={\setlength{\outermargin}{#1}},outermargin=\pal@undefdim,
  innermargin/.code={\setlength{\innermargin}{#1}},innermargin=\pal@undefdim,
  topmargin/.store in=\paloptions@topmargin,topmargin=-1sp,
  bottommargin/.code={\setlength{\bottommargin}{#1}},bottommargin=\pal@undefdim,
  gutter/.code={\setlength{\gutter}{#1}},gutter=0pt,
  pagecolor/.store in=\pal@pagecolor,
  pagegraphic/.store in=\paloptions@pagegraphic,pagegraphic=,
  color/.store in=\paloptions@color,color=black,
  grid/.is if=pal@grid,
  safezone/.is if=pal@safezone,
  cuttingmarks/.is if=pal@cuttingmarks,
  graphpaper/.is if=pal@graphpaper,
  placeholder/.is if=pal@placeholder,
  fillpages/.is if=pal@fillpages,
  draft/.code={\pal@placeholdertrue\pal@fillpagestrue\pal@cuttingmarkstrue\pal@isperformancemodetrue},
  preflight/.is if=pal@preflight,
  twoside/.is if=pal@twoside,
  fanfold/.code={\pal@fanfoldtrue\pal@covertrue\pal@twosidetrue\pal@beginlefttrue},
  cover/.is if=pal@cover,
  beginleft/.is if=pal@beginleft,
  beginright/.is if=pal@beginright,
  optimize/.code={\pal@optimizetrue\pgfkeys{optimize,#1}},
  density/.store in=\pal@density,
  quality/.store in=\pal@quality,
  turbo/.is if=pal@isturbomode,turbo=\ifpal@isluatex false\else true\fi,
  import/.is if=pal@import
}
\ProcessPgfOptions{/pal}

\pal@originalcolor{\paloptions@color}

\Gin@draftfalse

\LoadClass[multi=picture]{standalone}
\setlength{\topmargin}{\paloptions@topmargin}

% grid
\newdimen\pal@gridoffsetx
\newdimen\pal@gridwidth\newdimen\pal@gridheight\newdimen\pal@maxgridheight\newdimen\pal@maxgridwidth
\newcount\pal@gridtmp\newcount\pal@gridtmpRowH
\newcount\pal@rowscount\newcount\pal@flexrowscount\newcount\pal@fixrowscount\newcount\pal@cellscount
\newcount\rowsH\newcount\rowsF\newcount\rowsFlex
\newif\ifpal@gridisflexrow
\def\pal@set#1#2{
  \ifcsname pal@data#1\endcsname
  \else
    \expandafter\newcount\csname pal@data#1\endcsname
  \fi
  \csname pal@data#1\endcsname#2\relax
}
\def\pal@get#1{
  \ifcsname pal@data#1\endcsname
    \csname pal@data#1\endcsname%
  \else
    0
  \fi
}
\def\pal@advance#1#2{
  \advance\csname pal@data#1\endcsname by \csname pal@data#2\endcsname
}
\newif\ifpal@flexmode
\newif\ifpal@forcerow
\newif\ifpal@forcecell
\def\pal@leftsafetymargin{
  \ifpal@backcover%
    \pal@outersafetymargin%
  \else%
    \ifpal@frontcover%
      \pal@innersafetymargin%
    \else%
      \ifpal@leftpage%
        \pal@outersafetymargin%
      \else%
        \pal@innersafetymargin%
      \fi%
    \fi%
  \fi%
}
\def\pal@rightsafetymargin{
  \ifpal@backcover%
    \pal@innersafetymargin%
  \else%
    \ifpal@frontcover%
      \pal@outersafetymargin%
    \else%
      \ifpal@leftpage%
        \pal@innersafetymargin%
      \else%
        \pal@outersafetymargin%
      \fi%
    \fi%
  \fi%
}
\def\pal@leftbleed{
  \ifpal@backcover%
    \pal@outerbleed%
  \else%
    \ifpal@frontcover%
      \pal@innerbleed%
    \else%
      \ifpal@leftpage%
        \pal@outerbleed%
      \else%
        \pal@innerbleed%
      \fi%
    \fi%
  \fi%
}
\def\pal@rightbleed{
  \ifpal@backcover%
    \pal@innerbleed%
  \else%
    \ifpal@frontcover%
      \pal@outerbleed%
    \else%
      \ifpal@leftpage%
        \pal@innerbleed%
      \else%
        \pal@outerbleed%
      \fi%
    \fi%
  \fi%
}
\def\pal@leftmargin{
  \ifpal@backcover%
    \pal@outermargin%
  \else%
    \ifpal@frontcover%
      \pal@innermargin%
    \else%
      \ifpal@leftpage%
        \pal@outermargin%
      \else%
        \pal@innermargin%
      \fi%
    \fi%
  \fi%
}
\newcommand\pal@addrow[1]{
  \advance\pal@rowscount by 1
  \pal@cells#1
}
\newdimen\pal@gridheightdiff
\newdimen\pal@gridwidthdiff
\newdimen\pal@gridstartxdim
\newdimen\pal@gridstartydim
\newcount\looprows
\newcount\loopcells
\newcommand\pal@processrows{
  \advance\looprows 1
  \ifnum\pal@get{if\the\looprows F}=1
    \pal@set{\the\looprows HR}{\numexpr(\pal@gridheight-\pal@gutter*\pal@rowscount)*\pal@get{\the\looprows H}/\rowsH+\pal@gutter}
  \else
    \ifnum\pal@get{if\the\looprows Fix}=0
      \pal@set{\the\looprows HR}{\numexpr(\pal@maxgridheight-\pal@gridheight)*\pal@get{\the\looprows H}/\rowsFlex+\pal@gutter}
    \else
      \pal@set{\the\looprows HR}{\numexpr(\pal@gridwidth-\pal@gutter*\pal@get{\the\looprows C})*\pal@get{\the\looprows H}/\pal@get{\the\looprows W}+\pal@gutter}
    \fi
  \fi
  \loopcells=0
  \loop
    \advance\loopcells 1
    \ifnum\pal@get{if\the\looprows-\the\loopcells F}=1
      \pal@set{\the\looprows-\the\loopcells WR}{\numexpr(\pal@get{\the\looprows HR}-\pal@gutter)*\pal@get{\the\looprows-\the\loopcells W}/\pal@get{\the\looprows H}+\pal@gutter}
    \else
      \pal@set{\the\looprows-\the\loopcells WR}{\numexpr((\pal@gridwidth-\pal@gutter*\pal@get{\the\looprows C})\ifnum\pal@get{\the\looprows H}>0 -(\pal@get{\the\looprows HR}-\pal@gutter)*\pal@get{\the\looprows F}/\pal@get{\the\looprows H}\fi)*\pal@get{\the\looprows-\the\loopcells W}/(\pal@get{\the\looprows W}-\pal@get{\the\looprows F})+\pal@gutter}
    \fi
  \ifnum \loopcells<\pal@get{\the\looprows C}
  \repeat

  \ifnum \looprows<\pal@rowscount
    \pal@processrows
  \fi
}
\newcommand\pal@closerows{
  \pal@topmargin=\ifdim\pal@gridtopmargin=\pal@undefdim\pal@gridmargin\else\pal@gridtopmargin\fi
  \pal@bottommargin=\ifdim\pal@gridbottommargin=\pal@undefdim\pal@gridmargin\else\pal@gridbottommargin\fi
  \pal@innermargin=\ifdim\pal@gridinnermargin=\pal@undefdim\pal@gridmargin\else\pal@gridinnermargin\fi
  \pal@outermargin=\ifdim\pal@gridoutermargin=\pal@undefdim\pal@gridmargin\else\pal@gridoutermargin\fi

  \height=\dimexpr\pal@pageheight - \pal@topmargin - \pal@bottommargin\relax
  \width=\dimexpr\pal@pagewidth - \pal@innermargin - \pal@outermargin\relax
  \ifdim\dimexpr\pal@gridoptionheight\relax=\pal@undefdim
  \else
    \pal@gridheightdiff=\dimexpr0.5\height - 0.5\dimexpr\pal@gridoptionheight\relax\relax
    \pal@bottommargin=\dimexpr\pal@bottommargin+\pal@gridheightdiff\relax
    \pal@topmargin=\dimexpr\pal@topmargin+\pal@gridheightdiff\relax
  \fi
  \ifdim\dimexpr\pal@gridoptionwidth\relax=\pal@undefdim
  \else
    \pal@gridwidthdiff=\dimexpr\pal@calculaterealgridwidth/2 - 0.5\dimexpr\pal@gridoptionwidth\relax\relax
    \pal@innermargin=\dimexpr\pal@innermargin+\pal@gridwidthdiff\relax
    \pal@outermargin=\dimexpr\pal@outermargin+\pal@gridwidthdiff\relax
  \fi

  \pal@gutter=\pal@gridgutter

  \x=\dimexpr\pal@gridstartx{\pal@undefdim}-\pal@leftbleed\relax
  \y=\dimexpr\pal@gridstarty{\pal@undefdim}-\pal@bottombleed\relax

  \pal@gridstartxdim=\dimexpr\pal@gridstartx{\pal@gridoptionx} - \pal@gutter / 2\relax
  \pal@gridstartydim=\dimexpr\pal@gridstarty{\pal@gridoptiony} - \pal@gutter / 2\relax

  \pal@gridwidth=\dimexpr\pal@calculatefullgridwidth\relax
  \ifnum\rowsH>0
    \pal@calculategridheight
  \else
    \pal@gridheight=\dimexpr\pal@gutter*\pal@rowscount\relax
  \fi
  \pal@gridoffsetvertical=\pal@null
  \pal@gridoffsethorizontal=\pal@null
  \pal@gridoffsetverticaln=\pal@null
  \pal@gridoffsethorizontaln=\pal@null

  \pal@maxgridheight=\dimexpr\pal@calculatefullgridheight\relax
  \ifdim\pal@gridheight>\pal@maxgridheight
    \pal@gridheight=\pal@maxgridheight
    \pal@calculategridwidth
    \pal@gridoffsethorizontal=\dimexpr\pal@gridoptionhpos\pal@gridwidth-\pal@gridoptionhpos\pal@maxgridwidth\relax
    \pal@gridoffsethorizontaln=\dimexpr\pal@gridwidth-\pal@maxgridwidth-\pal@gridoffsethorizontal\relax
    \pal@gridwidth=\pal@maxgridwidth
  \else
    \ifpal@flexmode
    \else
      \ifdim\pal@gridheight<\pal@maxgridheight
        \pal@gridoffsetvertical=\dimexpr\pal@gridoptionvpos\pal@maxgridheight-\pal@gridoptionvpos\pal@gridheight\relax
        \pal@gridoffsetverticaln=\dimexpr\pal@maxgridheight-\pal@gridheight-\pal@gridoffsetvertical\relax
      \fi
    \fi
  \fi

  \looprows=0
  \pal@processrows
}
\newcommand\pal@addcell[1]{
  \advance\pal@cellscount by 1
  \if\pal@instring{!}{#1}
    \pal@gridtmp \pal@striplastexclamationmark{#1}\relax
    \pal@forcecelltrue
  \else
    \pal@gridisflexrowtrue
    \ifnum\numexpr0#1\relax=0
      \pal@gridtmp 1\relax
    \else
      \pal@gridtmp #1\relax
    \fi
    \pal@forcecellfalse
  \fi
  \pal@set{\the\pal@rowscount-\the\pal@cellscount W}{\pal@gridtmp}
  \ifpal@forcecell
    \pal@set{if\the\pal@rowscount-\the\pal@cellscount F}{1}
    \pal@advance{\the\pal@rowscount F}{\the\pal@rowscount-\the\pal@cellscount W}
  \else
    \pal@set{if\the\pal@rowscount-\the\pal@cellscount F}{0}
  \fi
  \pal@advance{\the\pal@rowscount W}{\the\pal@rowscount-\the\pal@cellscount W}
}
\newif\ifpal@gridtop
\newif\ifpal@gridbottom
\newif\ifpal@gridleft
\newif\ifpal@gridright
\newif\ifpal@gridfull
\pgfkeys{
  /grid/.is family,
  /grid,
  gutter/.store in=\pal@gridgutter,
  margin/.store in=\pal@gridmargin,
  top margin/.store in=\pal@gridtopmargin,
  bottom margin/.store in=\pal@gridbottommargin,
  inner margin/.store in=\pal@gridinnermargin,
  outer margin/.store in=\pal@gridoutermargin,
  width/.store in=\pal@gridoptionwidth,
  height/.store in=\pal@gridoptionheight,
  x/.store in=\pal@gridoptionx,
  y/.store in=\pal@gridoptiony,
  vpos/.store in=\pal@gridoptionvpos,
  hpos/.store in=\pal@gridoptionhpos,
}
\def\pal@resetautogrid{
  \global\pal@gridfullfalse
  \def\pal@framey{0}\def\pal@framex{0}\def\pal@frameyy{1}\def\pal@framexx{1}
  \def\pal@frameyymax{0}\def\pal@framexxmax{0}
}
\newcommand\setgrid[2][]{
  \ifpal@haspages
  \else
    \def\pal@tmpgrid{\setgrid{#2}}
  \fi
  \pal@resetautogrid
  \pgfkeys{
    /grid,
    gutter=\gutter,
    margin=\margin,
    top margin=\topmargin,
    bottom margin=\bottommargin,
    inner margin=\innermargin,
    outer margin=\outermargin,
    width=\pal@undefdim,
    height=\pal@undefdim,
    x=\pal@undefdim,
    y=\pal@undefdim,
    vpos=\pal@verticalpagealign,
    hpos=\pal@horizontalpagealign,%
    #1
  }
  \rowsH 0\relax
  \rowsFlex 0\relax
  \pal@flexrowscount 0\relax
  \pal@fixrowscount 0\relax
  \rowsF 0\relax
  \pal@rowscount 0\relax
  \pal@flexmodefalse
  \def\pal@grid@input{#2}
  \ifx\pal@grid@input\pal@emptystring
    \pal@gobblenextrow{{1}}
  \else
    \pal@gobblenextrow#2
  \fi
}
\newcommand\pal@gobblenextrow[1]{
  \pal@addrow{#1}
  \@ifnextchar\bgroup{
    \pal@gobblenextrow
  }{
    \ifpal@isinitgrid
    \else
      \pal@closerows
    \fi
  }
}
\newcommand\pal@cells[2][1]{
  \if\pal@instring{!}{#1}
    \pal@gridtmpRowH \pal@striplastexclamationmark{#1}\relax
    \pal@forcerowtrue
    \advance\rowsF by \pal@gridtmpRowH
    \advance\rowsH by \pal@gridtmpRowH
    \pal@set{\the\pal@rowscount H}{\pal@gridtmpRowH}
    \advance \pal@fixrowscount by 1
  \else
    \pal@forcerowfalse
    \pal@gridtmpRowH #1\relax
  \fi

  \pal@cellscount 0\relax
  \pal@set{\the\pal@rowscount W}{0}
  \pal@set{\the\pal@rowscount F}{0}
  \ifpal@forcerow\pal@set{if\the\pal@rowscount F}{1}\else\pal@set{if\the\pal@rowscount F}{0}\fi
  \pal@gridisflexrowfalse

  \pal@gobblenextcell{#2}
}
\newcommand\pal@gobblenextcell[1]{
  \pal@addcell{#1}
  \@ifnextchar\bgroup{
    \pal@gobblenextcell
  }{
    \ifpal@forcerow
    \else
      \ifpal@gridisflexrow
        \pal@flexmodetrue
        \advance \pal@flexrowscount by 1
        \advance\rowsFlex by \pal@gridtmpRowH
        \pal@set{\the\pal@rowscount H}{\pal@gridtmpRowH}
        \pal@set{if\the\pal@rowscount Fix}{0}
      \else
        \advance \pal@fixrowscount by 1
        \advance\rowsH by \pal@gridtmpRowH
        \pal@set{\the\pal@rowscount H}{\pal@gridtmpRowH}
        \pal@set{if\the\pal@rowscount Fix}{1}
      \fi
    \fi
    \pal@set{\the\pal@rowscount C}{\pal@cellscount}
  }
}

% grid shortcut
\def\pal@flexkey{f}
\def\pal@portraitkey{p}
\def\pal@squarekey{s}
\def\pal@landscapekey{l}
\def\pal@goldenkey{g}
\def\pal@goldenuprightkey{o}
\def\pal@widekey{w}
\def\pal@rowbreakkey{-}
\newcount\pal@rowcountsc
\newcount\pal@cellcountsc
\newcommand\pal@breakrow{
  \edef\pal@result{\pal@result{[30]\pal@rowindex}}
}
\newif\ifpal@isgridvalid
\newcommand\pal@transformgridconfig[1]{
  \ifx\pal@rowbreakkey#1
    \pal@breakrow
    \def\pal@rowindex{}
  \else
    \ifx\pal@flexkey#1
      \edef\pal@rowindex{\pal@rowindex{1}}
    \else
      \ifx\pal@portraitkey#1
        \edef\pal@rowindex{\pal@rowindex{20!}}
      \else
        \ifx\pal@squarekey#1
          \edef\pal@rowindex{\pal@rowindex{30!}}
        \else
          \ifx\pal@landscapekey#1
            \edef\pal@rowindex{\pal@rowindex{45!}}
          \else
            \ifx\pal@widekey#1
              \edef\pal@rowindex{\pal@rowindex{60!}}
            \else
              \ifx\pal@goldenkey#1
                \edef\pal@rowindex{\pal@rowindex{50!}}
              \else
                \ifx\pal@goldenuprightkey#1
                  \edef\pal@rowindex{\pal@rowindex{18!}}
                \else
                  \pal@isgridvalidfalse
                \fi
              \fi
            \fi
          \fi
        \fi
      \fi
    \fi
  \fi
}
\newcommand\pal@setplaceholder[1]{
  \ifx\pal@rowbreakkey#1
    \advance\pal@rowcountsc by 1
    \pal@cellcountsc 0\relax
  \else
    \placeholder{{\pal@rowcountsc} {\pal@cellcountsc} {\numexpr\pal@rowcountsc+1\relax} {\numexpr\pal@cellcountsc+1\relax}}
    \advance\pal@cellcountsc by 1
  \fi
}
\newcommand\pal@gridsc[1]{
  \edef\pal@gridsc@input{#1}
  \def\pal@rowindex{}
  \def\pal@result{}
  \pal@isgridvalidtrue
  \@tfor\next:=#1\do{\pal@transformgridconfig{\next}}%
  \ifpal@isgridvalid
    \pal@breakrow
    \edef\pal@result{{\pal@result}}
    \expandafter\setgrid\pal@result
    \pal@rowcountsc 0\relax
    \pal@cellcountsc 0\relax
    \@tfor\next:=#1\do{\pal@setplaceholder{\next}}%
  \else
    \pal@errmsg@undefined{template}{\pal@gridsc@input}
  \fi
}

% grid dimensions
\newif\ifpal@flexgrid
\newcommand\pal@calculategridheight{
  \pal@flexgridtrue
  \pal@gridheight=\pal@null
  \looprows=0
  \loop
    \advance\looprows 1
    \ifnum\pal@get{if\the\looprows F}=1
      \pal@gridheight=\dimexpr\pal@gridheight+\pal@gutter\relax%
    \else
      \ifnum\pal@get{if\the\looprows Fix}=0
        \pal@gridheight=\dimexpr\pal@gridheight+\pal@gutter\relax%
      \else
        \pal@flexgridfalse
        \pal@gridheight=\dimexpr\pal@gridheight+(\pal@gridwidth-\pal@gutter*\pal@get{\the\looprows C})*\pal@get{\the\looprows H}/(\pal@get{\the\looprows W}*(\rowsH-\rowsF))*\rowsH+\pal@gutter\relax
      \fi
    \fi
  \ifnum \looprows<\pal@rowscount
  \repeat
  \ifpal@flexgrid
    \pal@gridheight=\dimexpr\pal@calculatefullgridheight\relax
  \fi
}
\newcommand\pal@calculatefullgridheight{
  \pal@pageheight - \pal@topmargin - \pal@bottommargin + \pal@gutter
}
\newcommand\pal@calculategridwidth{
  \def\pal@calculategridwidthcalc{(\pal@gridheight*(\rowsH-\rowsF)/\rowsH-\pal@gutter*(\rowsH-\rowsF)*\pal@rowscount/\rowsH}
  \looprows=0
  \loop
    \advance\looprows 1
    \ifnum\pal@get{if\the\looprows F}=1
    \else
      \ifnum\pal@get{if\the\looprows Fix}=0
      \else
        \edef\pal@calculategridwidthcalc{\pal@calculategridwidthcalc+\pal@gutter*\pal@get{\the\looprows C}*\pal@get{\the\looprows H}/\pal@get{\the\looprows W}}
      \fi
    \fi
  \ifnum \looprows<\pal@rowscount
  \repeat

  \edef\pal@calculategridwidthcalc{\pal@calculategridwidthcalc) * 10000 / (\pal@null}
  \looprows=0
  \loop
    \advance\looprows 1
    \ifnum\pal@get{if\the\looprows F}=1
    \else
      \ifnum\pal@get{if\the\looprows Fix}=0
      \else
        \edef\pal@calculategridwidthcalc{\pal@calculategridwidthcalc+10000*\pal@get{\the\looprows H}/\pal@get{\the\looprows W}}
      \fi
    \fi
  \ifnum \looprows<\pal@rowscount
  \repeat

  \edef\pal@calculategridwidthcalc{\pal@calculategridwidthcalc)}
  \pal@maxgridwidth=\dimexpr\pal@calculategridwidthcalc\relax
}
\newcommand\pal@calculatefullgridwidth{
  \ifpal@isdoublepage
    \pal@pagewidth * 2 - \pal@outermargin * 2
    \ifpal@frontcover
    \else
      \ifpal@fanfold
      \else
        - \bindingoffset * 2
      \fi
    \fi
  \else
    \pal@pagewidth - \pal@innermargin - \pal@outermargin
  \fi
  + \pal@gutter
}
\newcommand\pal@calculaterealgridwidth{
  \ifpal@isdoublepage
    (\pal@pagewidth * 2 - \pal@outermargin * 2)
  \else
    (\pal@pagewidth - \pal@innermargin - \pal@outermargin)
  \fi
}
\newcommand\pal@gridstartx[1]{
  \ifdim\dimexpr#1\relax=\pal@undefdim
    \ifpal@isdoublepage
      (\pal@outermargin + \pal@leftbleed
      \ifpal@frontcover
      \else
        \ifpal@fanfold
        \else
          \ifpal@rightpage
            + \bindingoffset * 2
          \fi
        \fi
      \fi
      )
    \else
      (\pal@leftmargin + \pal@leftbleed)
    \fi
  \else%
    \ifpal@isdoublepage
      (#1 + \pal@leftbleed
      \ifpal@frontcover
      \else
        \ifpal@fanfold
        \else
          \ifpal@rightpage
            + \bindingoffset * 2
          \fi
        \fi
      \fi
      )
    \else
      (#1 + \pal@leftbleed)
    \fi
  \fi%
}
\newcommand\pal@gridstarty[1]{
  \ifdim\dimexpr#1\relax=\pal@undefdim
    (\pal@bottommargin + \pal@bottombleed)%
  \else%
    (#1 + \pal@bottombleed)
  \fi%
}
\newcommand\pal@setdimensions{
  \global\pal@gridfullfalse
  \global\def\pal@framey{0}\global\def\pal@framex{0}\global\def\pal@frameyy{1}\global\def\pal@framexx{1}
  \global\def\pal@frameyymax{0}\global\def\pal@framexxmax{0}
  \paperheight=\dimexpr(\pal@pageheight + \pal@topbleed + \pal@bottombleed)\relax
  \pal@gridoffsetx=\pal@null

  \ifpal@isdoublepage
    % doublepage
    \ifpal@fanfold
      \paperwidth=\dimexpr((\pal@pagewidth + \pal@outerbleed) * 2)\relax
    \else
      \paperwidth=\dimexpr(\pal@pagewidth + \pal@outerbleed + \pal@innerbleed)\relax
      \ifpal@rightpage
        \pal@gridoffsetx=\dimexpr(-\pal@pagewidth)\relax
      \fi
    \fi
  \else
    \ifpal@frontcover
      % frontcover
      \paperwidth=\dimexpr((\pal@pagewidth + \pal@outerbleed) * 2 + \spinewidth)\relax
    \else
      % page
      \ifpal@fanfold
        \paperwidth=\dimexpr((\pal@pagewidth + \pal@outerbleed) * 2)\relax
        \ifpal@rightpage
          \pal@gridoffsetx=\dimexpr(\pal@pagewidth + \pal@outerbleed - \pal@innerbleed)\relax
        \fi
      \else
        \paperwidth=\dimexpr(\pal@pagewidth + \pal@outerbleed + \pal@innerbleed)\relax
      \fi
    \fi
  \fi
}

% grid coordinates
\newcommand\pal@coordxrow[3]{\ifdim\dimexpr#2\dimexpr1pt\relax\relax<\dimexpr(#3\dimexpr1pt\relax-#1sp)\relax\the\numexpr#3\relax\else\pal@coordxrow{#1}{#2}{\numexpr#3+1\relax}\fi}
\newcommand\pal@coordxcell[2]{\ifnum\numexpr(10000*#1)\relax<\numexpr(#2*10000+1)\relax\the\numexpr#2\relax\else\pal@coordxcell{#1}{\numexpr#2+1\relax}\fi}
\newcommand\pal@coordx[3]{
  \pal@get{%
    \pal@coordxrow{#1}{#2}{1}-%
    \pal@coordxcell{#3}{1}%
    WR%
  }
}
\newcommand\posxcell[3]{
  \ifnum#3>0
    + \pal@coordx{#1}{#2}{#3}sp%
  \fi%
  \ifnum#3>1
    \posxcell{#1}{#2}{\numexpr#3-1\relax}%
  \fi%
}
\newcommand\posxrow[4]{
  \ifdim#4\dimexpr1pt\relax<\dimexpr#3\dimexpr1pt\relax+1sp\relax
    \pal@gridstartxdim + #4\dimexpr\pal@coordx{#1}{#2}{#3}sp\relax - \pal@coordx{#1}{#2}{#3}sp * \numexpr#3 - 1\relax\posxcell{#1}{#2}{\numexpr#3-1\relax}%
  \else%
    \posxrow{#1}{#2}{\numexpr#3+1\relax}{#4}%
  \fi%
}
\newcommand\posx[4]{
  \dimexpr(%
    \posxrow{#1}{#2}{1}{#4}
    + #3\pal@gutter / 2 + \pal@gridoffsetx + \pal@gridoffsethorizontal%
  )\relax%
}
\newcommand\posycell[1]{
  \ifnum#1>0
    - \pal@get{#1HR} sp
  \fi%
  \ifnum#1>1
    \posycell{\the\numexpr#1-1\relax}%
  \fi%
}
\newcommand\posyrow[2]{
  \ifdim#1\dimexpr1pt\relax<\dimexpr#2\dimexpr1pt\relax+1sp\relax
      \pal@gridstartydim + \pal@maxgridheight - #1\dimexpr\pal@get{#2HR} sp\relax + \pal@get{#2HR} sp * \numexpr#2 - 1\relax\posycell{\the\numexpr#2-1\relax}%
  \else
    \posyrow{#1}{\the\numexpr#2+1\relax}%
  \fi
}
\newcommand\posy[2]{
  \dimexpr(%
    \posyrow{#2}{1}
    - #1\pal@gutter / 2 - \pal@gridoffsetvertical%
  )\relax%
}
\newcommand\pal@gridhalign[1]{
  \def\pal@horizontalpagealign{#1}
}
\newcommand\pal@gridvalign[1]{
  \def\pal@verticalpagealign{#1}
}
\pal@gridhalign{0.5}
\pal@gridvalign{0.5}
\pal@isinitgridtrue
\setgrid{{{1}}}

% graphic
\newif\ifpal@isvisible
\newif\ifpal@calculatecrop
\newdimen\pal@originalgraphicwidth\newdimen\pal@originalgraphicheight
\newdimen\pal@cropx\newdimen\pal@cropy
\newdimen\pal@cropleft\newdimen\pal@cropright
\newdimen\pal@cropbottom\newdimen\pal@croptop
\newdimen\pal@cropstart\newdimen\pal@cropend
\newdimen\pal@snapleft\newdimen\pal@snapright
\newdimen\pal@snapbottom\newdimen\pal@snaptop
\newdimen\pal@viewportwidth\newdimen\pal@viewportheight
\newdimen\pal@frameborderwidth
\newdimen\pal@frameborderradius
\newdimen\pal@frameshadowradius
\newdimen\pal@snapcroptmp
\newdimen\pal@overprint
\pal@overprint=0pt
\def\pal@cropleftside{
  \ifdim\pal@x>\pal@cropstart
    \ifdim\pal@x<\pal@cropend
      \pal@snapleft=\dimexpr(\pal@x - \pal@cropstart)\relax
      \pal@x=\dimexpr(\pal@cropstart)\relax
    \fi
  \fi
}
\def\pal@croprightside{
  \ifdim\pal@xx>\pal@cropstart
    \ifdim\pal@xx<\pal@cropend
      \pal@snapright=\dimexpr(\pal@cropend - \pal@xx)\relax
      \pal@xx=\dimexpr(\pal@cropend)\relax
    \fi
  \fi
}
\def\pal@snapsafezonevertical{
  \pal@snapbottom=\pal@null
  \pal@snaptop=\pal@null
  \pal@cropstart=-\pal@overprint
  \pal@cropend=\dimexpr(\pal@null + \pal@bottombleed + 1pt)\relax
  \ifdim\pal@y>\pal@cropstart
    \ifdim\pal@y<\pal@cropend
      \pal@snapbottom=\dimexpr(\pal@y - \pal@cropstart)\relax
      \pal@y=\dimexpr(\pal@cropstart)\relax
    \fi
  \fi
  \pal@cropstart=\dimexpr(\pal@pageheight + \pal@bottombleed - 1pt)\relax
  \pal@cropend=\dimexpr(\pal@pageheight + \pal@bottombleed  + \pal@topbleed + \pal@overprint)\relax
  \ifdim\pal@yy>\pal@cropstart
    \ifdim\pal@yy<\pal@cropend
      \pal@snaptop=\dimexpr(\pal@cropend - \pal@yy)\relax
      \pal@yy=\dimexpr(\pal@cropend)\relax
    \fi
  \fi
}
\def\pal@snapsafezonehorizontal{
  \pal@snapleft=\pal@null
  \pal@snapright=\pal@null
  \ifpal@isdoublepage
    % doublepage
    \ifpal@fanfold
      \pal@cropstart=-\pal@overprint
      \pal@cropend=\dimexpr(\pal@null + \pal@leftbleed + 1pt)\relax
      \pal@cropleftside
      \pal@cropstart=\dimexpr(\pal@pagewidth * 2 + \pal@outerbleed - 1pt)\relax
      \pal@cropend=\dimexpr(\pal@pagewidth * 2 + \pal@outerbleed * 2 + \pal@overprint)\relax
      \pal@croprightside
    \else
      \pal@cropstart=-\pal@overprint
      \pal@cropend=\dimexpr(\pal@null + \pal@leftbleed + 1pt)\relax
      \pal@cropleftside
      \pal@cropstart=\dimexpr(\pal@pagewidth + \pal@outerbleed + \pal@innerbleed - \pal@rightbleed - 1pt)\relax
      \pal@cropend=\dimexpr(\pal@pagewidth + \pal@outerbleed + \pal@innerbleed + \pal@overprint)\relax
      \pal@croprightside
      \ifpal@leftpage
        \pal@cropstart=\dimexpr(\pal@pagewidth * 2 + \pal@outerbleed - \bindingoffset * 2 - 1pt)\relax
        \pal@cropend=\dimexpr(\pal@pagewidth * 2 + \pal@outerbleed + \pal@outerbleed - \bindingoffset * 2 + \pal@overprint)\relax
        \pal@croprightside
      \else
        \pal@cropstart=\dimexpr(\pal@innerbleed -\pal@pagewidth - \pal@outerbleed + \bindingoffset * 2 - \pal@overprint)\relax
        \pal@cropend=\dimexpr(-\pal@pagewidth + \pal@innerbleed + \bindingoffset * 2 + 1pt)\relax
        \pal@cropleftside
      \fi
    \fi
  \else
    % frontcover
    \ifpal@frontcover
      \ifpal@cover
        \ifpal@backcover
          \pal@cropstart=-\pal@overprint
          \pal@cropend=\dimexpr(\pal@null + \pal@leftbleed + 1pt)\relax
        \else
          \pal@cropstart=\dimexpr(\pal@pagewidth + \pal@outerbleed)\relax
          \pal@cropend=\dimexpr(\pal@pagewidth + \pal@outerbleed + \spinewidth + 1pt)\relax
        \fi
        \pal@cropleftside
        \ifpal@backcover
          \pal@cropstart=\dimexpr(\pal@pagewidth + \pal@outerbleed - 1pt)\relax
          \pal@cropend=\dimexpr(\pal@pagewidth + \pal@outerbleed)\relax
        \else
          \pal@cropstart=\dimexpr(\pal@pagewidth * 2 + \spinewidth + \pal@outerbleed - 1pt)\relax
          \pal@cropend=\dimexpr(\pal@pagewidth * 2 + \pal@outerbleed * 2 + \spinewidth + \pal@overprint)\relax
        \fi
        \pal@croprightside
      \else
        \pal@cropstart=-\pal@overprint
        \pal@cropend=\dimexpr(\pal@null + \pal@leftbleed + 1pt)\relax
        \pal@cropleftside
        \pal@cropstart=\dimexpr(\pal@pagewidth + \pal@outerbleed + \pal@innerbleed - \pal@rightbleed - 1pt)\relax
        \pal@cropend=\dimexpr(\pal@pagewidth + \pal@outerbleed + \pal@innerbleed + \pal@overprint)\relax
        \pal@croprightside
      \fi
    \else
      % page
      \ifpal@fanfold
        \pal@cropstart=-\pal@overprint
        \pal@cropend=\dimexpr(\pal@null + \pal@leftbleed + 1pt)\relax
        \pal@cropleftside
        \pal@cropstart=\dimexpr(\pal@pagewidth * 2 + \pal@outerbleed - 1pt)\relax
        \pal@cropend=\dimexpr(\pal@pagewidth * 2 + \pal@outerbleed * 2 + \pal@overprint)\relax
        \pal@croprightside
      \else
        \pal@cropstart=-\pal@overprint
        \pal@cropend=\dimexpr(\pal@null + \pal@leftbleed + 1pt)\relax
        \pal@cropleftside
        \pal@cropstart=\dimexpr(\pal@pagewidth + \pal@outerbleed + \pal@innerbleed - \pal@rightbleed - 1pt)\relax
        \pal@cropend=\dimexpr(\pal@pagewidth + \pal@outerbleed + \pal@innerbleed + \pal@overprint)\relax
        \pal@croprightside
      \fi
    \fi
  \fi
}
\pgfkeys{
  /graphic/.is family,
  /graphic,
  file/.store in=\pal@graphicoptionfile,
  scale/.store in=\pal@graphicoptionscale,
  vpos/.store in=\pal@graphicoptionvpos,
  hpos/.store in=\pal@graphicoptionhpos,
  unsharp/.store in=\pal@graphicoptionunsharp,
  border/.forward to=/defaultborder/name,
  border radius/.forward to=/defaultborder/radius,
  border width/.forward to=/defaultborder/width,
  border color/.forward to=/defaultborder/color,
  border opacity/.forward to=/defaultborder/opacity,
  shadow/.forward to=/defaultshadow/name,
  shadow size/.forward to=/defaultshadow/size,
  shadow color/.forward to=/defaultshadow/color,
  shadow opacity/.forward to=/defaultshadow/opacity,
  shadow xshift/.forward to=/defaultshadow/xshift,
  shadow yshift/.forward to=/defaultshadow/yshift,
}
\def\pal@checkvisibility{
  \pal@isvisibletrue

  \ifpal@frontcover
  \else
    \ifpal@fanfold
    \else
      \ifpal@isdoublepage
        \ifpal@leftpage
          \pal@cropstart=\dimexpr(\pal@pagewidth + \pal@outerbleed - \bindingoffset - 1pt)\relax
          \pal@cropend=\dimexpr(\pal@pagewidth + \pal@outerbleed + \pal@innerbleed)\relax
          \ifdim\pal@x>\pal@cropstart
            \pal@isvisiblefalse
          \fi
        \else
          \pal@cropstart=\dimexpr(\pal@null)\relax
          \pal@cropend=\dimexpr(\pal@null + \pal@leftbleed + \bindingoffset + 1pt)\relax
          \ifdim\pal@xx<\pal@cropend
            \pal@isvisiblefalse
          \fi
        \fi
      \fi
    \fi
  \fi
}
\def\pal@snapoptimizedgraphic{
  \ifdim\pal@snapleft>\pal@null
    \width=\dimexpr\width+\pal@snapleft\relax
  \fi
  \ifdim\pal@snapright>\pal@null
    \width=\dimexpr\width+\pal@snapright\relax
  \fi
  \ifdim\pal@snaptop>\pal@null
    \height=\dimexpr\height+\pal@snaptop\relax
  \fi
  \ifdim\pal@snapbottom>\pal@null
    \height=\dimexpr\height+\pal@snapbottom\relax
  \fi
}
\def\pal@snapgraphic{
  \pgfmathqparse{(\pal@originalgraphicheight-\pal@croptop-\pal@cropbottom)/\height}
  \edef\pal@scale{\pgfmathresult}
  \pgfmathqparse{\height/(\pal@originalgraphicheight-\pal@croptop-\pal@cropbottom)}
  \edef\pal@scalerez{\pgfmathresult}

  % snap
  \ifdim\pal@snapleft>\pal@null
    \ifdim\pal@cropleft>\pal@null
      \ifdim\pal@scale\pal@snapleft>\pal@cropleft
        \pal@snapbleedleft=\pal@cropleft
        \pal@snapleft=\dimexpr\pal@snapleft-\pal@scalerez\pal@cropleft\relax
        \width=\dimexpr\width+\pal@scalerez\pal@cropleft\relax
        \pal@cropleft=\pal@null
      \else
        \pal@snapbleedleft=\dimexpr\pal@scale\pal@snapleft\relax
        \pal@cropleft=\dimexpr\pal@cropleft-\pal@scale\pal@snapleft\relax
        \width=\dimexpr\width+\pal@snapleft\relax
        \pal@snapleft=\pal@null
      \fi
    \fi
  \fi
  \ifdim\pal@snapright>\pal@null
    \ifdim\pal@cropright>\pal@null
      \ifdim\pal@scale\pal@snapright>\pal@cropright
        \pal@snapbleedright=\pal@cropright
        \pal@snapright=\dimexpr\pal@snapright-\pal@scalerez\pal@cropright\relax
        \width=\dimexpr\width+\pal@scalerez\pal@cropright\relax
        \pal@cropright=\pal@null
      \else
        \pal@snapbleedright=\dimexpr\pal@scale\pal@snapright\relax
        \pal@cropright=\dimexpr\pal@cropright-\pal@scale\pal@snapright\relax
        \width=\dimexpr\width+\pal@snapright\relax
        \pal@snapright=\pal@null
      \fi
    \fi
  \fi
  \ifdim\pal@snaptop>\pal@null
    \ifdim\pal@croptop>\pal@null
      \ifdim\pal@scale\pal@snaptop>\pal@croptop
        \pal@snapbleedtop=\pal@croptop
        \pal@snaptop=\dimexpr\pal@snaptop-\pal@scalerez\pal@croptop\relax
        \height=\dimexpr\height+\pal@scalerez\pal@croptop\relax
        \pal@croptop=\pal@null
      \else
        \pal@snapbleedtop=\dimexpr\pal@scale\pal@snaptop\relax
        \pal@croptop=\dimexpr\pal@croptop-\pal@scale\pal@snaptop\relax
        \height=\dimexpr\height+\pal@snaptop\relax
        \pal@snaptop=\pal@null
      \fi
    \fi
  \fi
  \ifdim\pal@snapbottom>\pal@null
    \ifdim\pal@cropbottom>\pal@null
      \ifdim\pal@scale\pal@snapbottom>\pal@cropbottom
        \pal@snapbleedbottom=\pal@cropbottom
        \pal@snapbottom=\dimexpr\pal@snapbottom-\pal@scalerez\pal@cropbottom\relax
        \height=\dimexpr\height+\pal@scalerez\pal@cropbottom\relax
        \pal@cropbottom=\pal@null
      \else
        \pal@snapbleedbottom=\dimexpr\pal@scale\pal@snapbottom\relax
        \pal@cropbottom=\dimexpr\pal@cropbottom-\pal@scale\pal@snapbottom\relax
        \height=\dimexpr\height+\pal@snapbottom\relax
        \pal@snapbottom=\pal@null
      \fi
    \fi
  \fi

  % move
  \ifdim\pal@snapbottom=\pal@null
    \ifdim\pal@snaptop=\pal@null
      \ifdim\pal@snapright>\pal@null
        \ifdim\pal@cropleft>\pal@null
          \ifdim\pal@scale\pal@snapright>\pal@cropleft
            \pal@snapright=\dimexpr\pal@snapright-\pal@scalerez\pal@cropleft\relax
            \width=\dimexpr\width+\pal@scalerez\pal@cropleft\relax
            \pal@cropleft=\pal@null
          \else
            \pal@cropleft=\dimexpr\pal@cropleft-\pal@scale\pal@snapright\relax
            \width=\dimexpr\width+\pal@snapright\relax
            \pal@snapright=\pal@null
          \fi
        \fi
      \fi
      \ifdim\pal@snapleft>\pal@null
        \ifdim\pal@cropright>\pal@null
          \ifdim\pal@scale\pal@snapleft>\pal@cropright
            \pal@snapleft=\dimexpr\pal@snapleft-\pal@scalerez\pal@cropright\relax
            \width=\dimexpr\width+\pal@scalerez\pal@cropright\relax
            \pal@cropright=\pal@null
          \else
            \pal@cropright=\dimexpr\pal@cropright-\pal@scale\pal@snapleft\relax
            \width=\dimexpr\width+\pal@snapleft\relax
            \pal@snapleft=\pal@null
          \fi
        \fi
      \fi
    \fi
  \fi
  \ifdim\pal@snapleft=\pal@null
    \ifdim\pal@snapright=\pal@null
      \ifdim\pal@snaptop>\pal@null
        \ifdim\pal@cropbottom>\pal@null
          \ifdim\pal@scale\pal@snaptop>\pal@cropbottom
            \pal@snaptop=\dimexpr\pal@snaptop-\pal@scalerez\pal@cropbottom\relax
            \height=\dimexpr\height+\pal@scalerez\pal@cropbottom\relax
            \pal@cropbottom=\pal@null
          \else
            \pal@cropbottom=\dimexpr\pal@cropbottom-\pal@scale\pal@snaptop\relax
            \height=\dimexpr\height+\pal@snaptop\relax
            \pal@snaptop=\pal@null
          \fi
        \fi
      \fi
      \ifdim\pal@snapbottom>\pal@null
        \ifdim\pal@croptop>\pal@null
          \ifdim\pal@scale\pal@snapbottom>\pal@croptop
            \pal@snapbottom=\dimexpr\pal@snapbottom-\pal@scalerez\pal@croptop\relax
            \height=\dimexpr\height+\pal@scalerez\pal@croptop\relax
            \pal@croptop=\pal@null
          \else
            \pal@croptop=\dimexpr\pal@croptop-\pal@scale\pal@snapbottom\relax
            \height=\dimexpr\height+\pal@snapbottom\relax
            \pal@snapbottom=\pal@null
          \fi
        \fi
      \fi
    \fi
  \fi
}
\newdimen\pal@snapcropoffset
\newdimen\pal@snapbleedleft\newdimen\pal@snapbleedright
\newdimen\pal@snapbleedtop\newdimen\pal@snapbleedbottom
\def\pal@hscalegraphic{
  \pgfmathqparse{\width/(\width+\pal@snapleft+\pal@snapright)}
  \edef\pal@snapscale{\pgfmathresult}
  \pal@snapcroptmp=\dimexpr\pal@originalgraphicheight-\pal@cropbottom-\pal@croptop-\pal@snapscale\pal@originalgraphicheight+\pal@snapscale\pal@cropbottom+\pal@snapscale\pal@croptop\relax
  \pal@snapcropoffset=\dimexpr\pal@snapbleedbottom-\pal@snapscale\pal@snapbleedbottom-\pal@snapbleedtop+\pal@snapscale\pal@snapbleedtop\relax
  \pal@cropbottom=\dimexpr\pal@cropbottom+0.5\pal@snapcroptmp+0.5\pal@snapcropoffset\relax
  \pal@croptop=\dimexpr\pal@croptop+0.5\pal@snapcroptmp-0.5\pal@snapcropoffset\relax

  \width=\dimexpr\width+\pal@snapleft+\pal@snapright\relax
  \pal@snapright=\pal@null
  \pal@snapleft=\pal@null
}
\def\pal@vscalegraphic{
  \pgfmathqparse{\height/(\height+\pal@snaptop+\pal@snapbottom)}
  \edef\pal@snapscale{\pgfmathresult}
  \pal@snapcroptmp=\dimexpr\pal@originalgraphicwidth-\pal@cropleft-\pal@cropright-\pal@snapscale\pal@originalgraphicwidth+\pal@snapscale\pal@cropleft+\pal@snapscale\pal@cropright\relax
  \pal@snapcropoffset=\dimexpr\pal@snapbleedleft-\pal@snapscale\pal@snapbleedleft-\pal@snapbleedright+\pal@snapscale\pal@snapbleedright\relax
  \pal@cropleft=\dimexpr\pal@cropleft+0.5\pal@snapcroptmp+0.5\pal@snapcropoffset\relax
  \pal@cropright=\dimexpr\pal@cropright+0.5\pal@snapcroptmp-0.5\pal@snapcropoffset\relax

  \height=\dimexpr\height+\pal@snaptop+\pal@snapbottom\relax
  \pal@snaptop=\pal@null
  \pal@snapbottom=\pal@null
}
\def\pal@getbase#1{\edef\Gin@base{\filename@area\filename@base}\edef\Gin@ext{#1}}
\let\pal@getbaseorginal\Gin@getbase
\def\pal@disablegraphicsfilecheck{
  \let\Gin@getbase\pal@getbase
}
\def\pal@enablegraphicsfilecheck{
  \let\Gin@getbase\pal@getbaseorginal
}
\let\pal@setfileorginal\Gin@setfile
\def\pal@setfile#1#2#3{
  \global\edef\pal@currfilebase{\Gin@base}
  \global\edef\pal@currfileext{\Gin@ext}
  \global\@onelevel@sanitize\pal@currfileext
}
\edef\pal@extjpeg{.jpeg}\@onelevel@sanitize\pal@extjpeg
\edef\pal@extJPEG{.JPEG}\@onelevel@sanitize\pal@extJPEG
\edef\pal@extjpg{.jpg}\@onelevel@sanitize\pal@extjpg
\edef\pal@extJPG{.JPG}\@onelevel@sanitize\pal@extJPG
\edef\pal@extpng{.png}\@onelevel@sanitize\pal@extpng
\edef\pal@extPNG{.PNG}\@onelevel@sanitize\pal@extPNG
\def\isoptimizable#1#2{
  \ifx#1\pal@extjpg
    \def\pal@optimizedext{.jpg}#2
  \else
    \ifx#1\pal@extJPG
      \def\pal@optimizedext{.jpg}#2
    \else
      \ifx#1\pal@extjpeg
        \def\pal@optimizedext{.jpg}#2
      \else
        \ifx#1\pal@extJPEG
          \def\pal@optimizedext{.jpg}#2
        \else
          \ifx#1\pal@extpng
            \def\pal@optimizedext{.png}#2
          \else
            \ifx#1\pal@extPNG
              \def\pal@optimizedext{.png}#2
            \fi
          \fi
        \fi
      \fi
    \fi
  \fi
}
\def\newgraphic#1#2{
  \expandafter\newcommand\csname pal@graphic@#1\endcsname[2][0]{%
    \ifnum##1=0
      \pgfkeys{pagegraphic,file={#1},scale=1,vpos=0.5,hpos=0.5,unsharp=\pal@unsharp,#2,##2}
    \else
      \ifnum##1=1
        \pgfkeys{backcoverpagegraphic,file={#1},scale=1,vpos=0.5,hpos=0.5,unsharp=\pal@unsharp,#2}
      \else
        \pgfkeys{graphic,file={#1},scale=1,vpos=0.5,hpos=0.5,unsharp=\pal@unsharp,#2,##2}
      \fi
    \fi
  }%
}
\newcommand\pal@putgraphic[6][]{
  \pal@x=\posx{1}{#2}{1}{#3}
  \pal@yy=\posy{1}{#2}
  \pal@xx=\posx{-1}{#4}{-1}{#5}
  \pal@y=\posy{-1}{#4}

  \pal@checkvisibility

  \ifpal@isvisible
    \pal@cropleft=\pal@null
    \pal@cropbottom=\pal@null
    \pal@cropright=\pal@null
    \pal@croptop=\pal@null

    \width=\dimexpr(\pal@xx - \pal@x)\relax
    \height=\dimexpr(\pal@yy - \pal@y)\relax

    % safezone horizontal
    \pal@snapsafezonehorizontal

    % safezone vertical
    \pal@snapsafezonevertical

    \pal@snapbleedleft=\pal@null
    \pal@snapbleedright=\pal@null
    \pal@snapbleedtop=\pal@null
    \pal@snapbleedbottom=\pal@null

    \begingroup
    \xdef\pal@filename{#6-\pal@density-\pal@graphicoptionscale-\pal@graphicoptionhpos-\pal@graphicoptionvpos-\the\numexpr\pal@snaptop\relax-\the\numexpr\pal@snapright\relax-\the\numexpr\pal@snapbottom\relax-\the\numexpr\pal@snapleft\relax-\the\numexpr\width\relax-\the\numexpr\height\relax-\pal@downsamplethreshold-\pal@graphicoptionunsharp-\pal@quality}
    \ifpal@optimize
      \IfFileExists{./cache/\pal@filename/g.jpg}{
        \def\pal@nextincludegraphic{\includegraphics[width=\width]{cache/\pal@filename/g.jpg}}
      }{
        \IfFileExists{./cache/\pal@filename/g.png}{
          \def\pal@nextincludegraphic{\includegraphics[width=\width]{cache/\pal@filename/g.png}}
        }{
          \pal@calculatecroptrue
        }
      }

      \ifpal@preflight
        \pal@calculatecroptrue
      \fi
    \else
      \pal@calculatecroptrue
    \fi

    \ifpal@calculatecrop
      \global\edef\pal@currfilebase{}
      \global\edef\pal@currfileext{}
      \let\Gin@setfile\pal@setfile
      \Ginclude@graphics#6
      \let\Gin@setfile\pal@setfileorginal
      \ifx\pal@currfileext\pal@emptystring
        \pal@calculatecropfalse
        \def\pal@nextincludegraphic{}
      \fi
    \fi

    \pal@disablegraphicsfilecheck
    \ifpal@calculatecrop
      % graphic crop
      \settowidth{\pal@originalgraphicwidth}{\includegraphics{\pal@currfilebase\pal@currfileext}}
      \settoheight{\pal@originalgraphicheight}{\includegraphics{\pal@currfilebase\pal@currfileext}}
      \pgfmathqparse{1pt-\pal@graphicoptionvpos pt}
      \edef\pal@graphicoptionvpos{\pgfmathresult}
      \pgfmathqparse{\pal@originalgraphicwidth/\pal@originalgraphicheight}
      \edef\pal@graphicratio{\pgfmathresult}
      \pgfmathqparse{\width/\height}
      \edef\pal@vpratio{\pgfmathresult}
      \pgfmathqparse{\pal@graphicratio pt>\pal@vpratio pt}
      \ifnum\pgfmathresult=1
        \pal@cropx=\dimexpr(\numexpr(\pal@originalgraphicwidth - \width * \pal@originalgraphicheight / \height)\relax sp)\relax
        \pal@cropy=\pal@null
      \else
        \pal@cropy=\dimexpr(\numexpr(\pal@originalgraphicheight - \height * \pal@originalgraphicwidth / \width)\relax sp)\relax
        \pal@cropx=\pal@null
      \fi
      \pal@viewportwidth=\dimexpr\pal@originalgraphicwidth-\pal@cropx\relax
      \pal@viewportheight=\dimexpr\pal@originalgraphicheight-\pal@cropy\relax
      \pgfmathqparse{1pt/\pal@graphicoptionscale pt}
      \edef\pal@reciprocalscale{\pgfmathresult}
      \pal@cropx=\dimexpr\pal@cropx + \pal@viewportwidth - \pal@reciprocalscale\pal@viewportwidth\relax
      \pal@cropy=\dimexpr\pal@cropy + \pal@viewportheight - \pal@reciprocalscale\pal@viewportheight\relax
      \ifdim\pal@cropx>\pal@null
        \pal@cropleft=\dimexpr(\pal@graphicoptionhpos\pal@cropx)\relax
        \ifdim\pal@cropleft<\pal@null
          \pal@cropleft=\pal@null
        \fi
        \ifdim\pal@cropleft>\pal@cropx
          \pal@cropleft=\pal@cropx
        \fi
        \pal@cropright=\dimexpr(\pal@cropx - \pal@cropleft)\relax
      \fi
      \ifdim\pal@cropy>\pal@null
        \pal@cropbottom=\dimexpr(\pal@graphicoptionvpos\pal@cropy)\relax
        \ifdim\pal@cropbottom<\pal@null
          \pal@cropbottom=\pal@null
        \fi
        \ifdim\pal@cropbottom>\pal@cropy
          \pal@cropbottom=\pal@cropy
        \fi
        \pal@croptop=\dimexpr(\pal@cropy - \pal@cropbottom)\relax
      \fi

      \pal@snapgraphic
      \ifdim\dimexpr\pal@snapleft+\pal@snapright\relax=\pal@null
        \ifdim\dimexpr\pal@snaptop+\pal@snapbottom\relax>\pal@null
          \pal@vscalegraphic
        \fi
      \else
        \ifdim\dimexpr\pal@snaptop+\pal@snapbottom\relax=\pal@null
          \ifdim\dimexpr\pal@snapleft+\pal@snapright\relax>\pal@null
            \pal@hscalegraphic
          \fi
        \else
          \ifdim\dimexpr\width/(\pal@snapleft + \pal@snapright)\relax<\dimexpr\height/(\pal@snaptop + \pal@snapbottom)\relax
            \pal@hscalegraphic

            \pal@snapgraphic
          \else
            \pal@vscalegraphic

            \pal@snapgraphic
          \fi
        \fi
      \fi

      \ifdim\pal@snapleft>\pal@null
        \pal@x=\dimexpr\pal@x+\pal@snapleft\relax
      \fi
      \ifdim\pal@snapbottom>\pal@null
        \pal@y=\dimexpr\pal@y+\pal@snapbottom\relax
      \fi
    \else
      \pal@snapoptimizedgraphic
    \fi

    \ifdefined\pal@nextincludegraphic
    \else
      \ifpal@optimize
        \ifpal@isbatchmode
          \isoptimizable{\pal@currfileext}{\pal@addtobatchlist{\pal@currfilebase}{\pal@currfileext}}
          \def\pal@nextincludegraphic{}
        \else
          \isoptimizable{\pal@currfileext}{\pal@optimizegraphic{\pal@currfilebase}{\pal@currfileext}}
          \ifdefined\pal@optimizedext
            \IfFileExists{./cache/\pal@filename/g\pal@optimizedext}{
              \def\pal@nextincludegraphic{\includegraphics[width=\width]{cache/\pal@filename/g\pal@optimizedext}}
            }{
              \ifx\pal@processresult\pal@ok
                \ClassError{pagelayout}{Unexpected error. File not optimized}{File `cache/#6/g\pal@optimizedext' not found.\MessageBreak Try to delete the `cache' directory.\MessageBreak\MessageBreak\@ehc}
              \fi
              \def\pal@nextincludegraphic{\includegraphics[trim={\pal@cropleft} {\pal@cropbottom} {\pal@cropright} {\pal@croptop},\pal@clip,width=\width]{\pal@currfilebase\pal@currfileext}}
            }
          \else
            \def\pal@nextincludegraphic{\includegraphics[trim={\pal@cropleft} {\pal@cropbottom} {\pal@cropright} {\pal@croptop},\pal@clip,width=\width]{\pal@currfilebase\pal@currfileext}}
          \fi
        \fi
      \else
        \def\pal@nextincludegraphic{\includegraphics[trim={\pal@cropleft} {\pal@cropbottom} {\pal@cropright} {\pal@croptop},\pal@clip,width=\width]{\pal@currfilebase\pal@currfileext}}
      \fi
    \fi

    \ifdim\pal@defaultborderradius>0.5\height
      \def\pal@defaultborderradius{0.5\height}
    \fi
    \ifdim\pal@defaultborderradius>0.5\width
      \def\pal@defaultborderradius{0.5\width}
    \fi

    \pal@frameborderwidth=\dimexpr\pal@defaultborderwidth\relax
    \ifdim\pal@defaultborderradius=0pt
      \pal@frameborderradius=0pt
      \pal@frameshadowradius=0pt
    \else
      \pal@frameborderradius=\dimexpr\pal@defaultborderradius+0.5\pal@frameborderwidth\relax
      \pal@frameshadowradius=\dimexpr\pal@defaultborderradius+\pal@frameborderwidth\relax
    \fi

    % draw shadow
    \ifpal@isbatchmode
    \else
      \def\pal@frameshadowoffsetx{\pal@frameborderwidth}
      \def\pal@frameshadowoffsety{\pal@frameborderwidth}
      \def\pal@frameshadowwidth{\dimexpr\width+10cm+2\pal@frameborderwidth\relax}
      \def\pal@frameshadowheight{\dimexpr\height+10cm+2\pal@frameborderwidth\relax}
      \def\pal@frameshadowframewidth{\dimexpr\width+2\pal@frameborderwidth\relax}
      \def\pal@frameshadowframeheight{\dimexpr\height+2\pal@frameborderwidth\relax}
      \def\pal@frameshadowborder{\dimexpr5cm\relax}
      \pal@drawshadow
    \fi

    % draw graphic and border
    \ifpal@isbatchmode
      \pal@ismaskrequiredfalse
      \def\pal@nextincludegraphic{}
    \else
      \ifpal@isperformancemode
        \ifdim\pal@defaultborderwidth>0pt
          \pal@ismaskrequiredtrue
        \else
          \ifdim\pal@defaultborderradius>0pt
            \pal@ismaskrequiredtrue
          \else
            \pal@ismaskrequiredfalse
          \fi
        \fi
      \else
        \pal@ismaskrequiredtrue
      \fi
    \fi

    \ifpal@ismaskrequired
      \def\pal@clip{}%
    \else
      \def\pal@clip{clip}%
    \fi

    \put(\pal@dimentonumber{\pal@x},\pal@dimentonumber{\pal@y}){%
      \ifpal@ismaskrequired%
        \begin{tikzpicture}%
          \pgflowlevelsynccm%
          \ifdim\pal@defaultborderwidth>0pt
            \draw[draw=\pal@defaultbordercolor,draw opacity=\pal@defaultborderopacity,line width=\pal@frameborderwidth,rounded corners=\pal@frameborderradius] (-0.5\pal@frameborderwidth,-0.5\pal@frameborderwidth) rectangle ++(\width+\pal@frameborderwidth,\height+\pal@frameborderwidth);%
          \fi

          \draw[draw opacity=0,rounded corners=\pal@defaultborderradius,path picture={
            \node at (0.5\width,0.5\height){
              \pal@nextincludegraphic
            };
          }] (0,0) rectangle ++(\width,\height);%
        \end{tikzpicture}%
      \else%
        \pal@nextincludegraphic
      \fi%
    }

    \pal@enablegraphicsfilecheck

    % draw ppi
    \ifpal@preflight
      \ifx\pal@nextincludegraphic\pal@emptystring
      \else
        \isoptimizable{\pal@currfileext}{\pal@getppi{\pal@currfilebase\pal@currfileext}}
        \ifdefined\pal@graphicdensity
          \pal@drawppi{#2}{#3}{#4}{#5}{#6}{\pal@graphicdensity}
        \fi
      \fi
    \fi
    \endgroup
  \fi
}
\newcommand\pal@drawppi[6]{
  \pal@x=\posx{1}{#1}{1}{#2}
  \pal@yy=\posy{1}{#1}
  \pal@xx=\posx{-1}{#3}{-1}{#4}
  \pal@y=\posy{-1}{#3}
  \width=\dimexpr(\pal@xx - \pal@x)\relax
  \height=\dimexpr(\pal@yy - \pal@y)\relax
  \pal@x=\dimexpr(\pal@x + \width)\relax
  \pal@y=\dimexpr(\pal@y + \height)\relax
  \ifpal@frontcover
    \ifdim\pal@x>\dimexpr2\pal@pagewidth+2\pal@outerbleed+\spinewidth\relax
      \pal@x=\dimexpr2\pal@pagewidth+2\pal@outerbleed+\spinewidth\relax
    \fi
  \else
    \ifpal@fanfold
      \ifdim\pal@x>\dimexpr2\pal@pagewidth+2\pal@outerbleed\relax
        \pal@x=\dimexpr2\pal@pagewidth+2\pal@outerbleed\relax
      \fi
    \else
      \ifdim\pal@x>\dimexpr\pal@pagewidth+\pal@innerbleed+\pal@outerbleed\relax
        \pal@x=\dimexpr\pal@pagewidth+\pal@innerbleed+\pal@outerbleed\relax
      \fi
    \fi
  \fi
  \ifdim\pal@y>\dimexpr\pal@pageheight+\pal@topbleed+\pal@bottombleed\relax
    \pal@y=\dimexpr\pal@pageheight+\pal@topbleed+\pal@bottombleed\relax
  \fi
  \def\pal@ppicolor{green!50!black}
  \def\pal@ppicolortext{white}
  \ifnum#6<300
    \def\pal@ppicolor{yellow}
    \def\pal@ppicolortext{black}
    \ifnum#6<200
      \def\pal@ppicolor{red}
      \def\pal@ppicolortext{white}
      \pal@errmsg@lowdensity{1}{#5}{#6}
    \else
      \pal@errmsg@lowdensity{0}{#5}{#6}
    \fi
  \fi
  \put(\pal@dimentonumber{\pal@x},\pal@dimentonumber{\pal@y}){%
    \begin{tikzpicture}%
      \pgflowlevelsynccm%
      \node[fill=\pal@ppicolor,fill opacity=0.9,line width=0pt,anchor=north east] at (0,0){
        \color{\pal@ppicolortext}\textbf{#6ppi}
      };
    \end{tikzpicture}%
  }
}

% pagegraphic
\def\pal@pagegraphic{}
\pgfkeys{
  /pagegraphic/.is family,
  /pagegraphic,
  file/.store in=\pal@pagegraphic,
  scale/.store in=\pal@pagegraphicoptionscale,
  vpos/.store in=\pal@pagegraphicoptionvpos,
  hpos/.store in=\pal@pagegraphicoptionhpos,
  unsharp/.store in=\pal@pagegraphicoptionunsharp,
}
\pgfkeys{
  /backcoverpagegraphic/.is family,
  /backcoverpagegraphic,
  file/.store in=\pal@backcoveroptionpagegraphicfile,
  scale/.store in=\pal@backcoveroptionpagegraphicscale,
  vpos/.store in=\pal@backcoveroptionpagegraphicvpos,
  hpos/.store in=\pal@backcoveroptionpagegraphichpos,
  unsharp/.store in=\pal@backcoveroptionpagegraphicunsharp,
}
\def\pal@putpagegraphic{
  \begingroup
    \margin=\pal@null
    \topmargin=\pal@null
    \bottommargin=\pal@null
    \innermargin=\pal@null
    \outermargin=\pal@null
    \setgrid{{{1}}}
    \pgfkeys{graphic,scale=\pal@pagegraphicoptionscale,hpos=\pal@pagegraphicoptionhpos,vpos=\pal@pagegraphicoptionvpos,unsharp=\pal@pagegraphicoptionunsharp,border width=0pt,border radius=0pt,shadow size=0,shadow xshift=0pt,shadow yshift=0pt}
    \pal@putgraphic{0}{0}{1}{1}{\pal@pagegraphic}
  \endgroup
}
\newcommand\setpagegraphic[2][]{
  \ifcsname pal@graphic@#2\endcsname%
    \csname pal@graphic@#2\endcsname{#1}
  \else%
    \pgfkeys{pagegraphic,file={#2},scale=1,vpos=0.5,hpos=0.5,unsharp=\pal@unsharp,#1}
  \fi
}
\def\nopagegraphic{\setpagegraphic{}}

% text
\newdimen\pal@textboxheight
\newdimen\pal@textboxwidth
\newdimen\pal@leftwidth
\newdimen\pal@rightwidth
\newcommand\pal@checkside[1]{
  \ifpal@fanfold
    \ifpal@isdoublepage
      \pal@leftwidth=\dimexpr(\pal@pagewidth + \pal@outerbleed - \pal@x)\relax
      \pal@rightwidth=\dimexpr(\pal@xx - \pal@pagewidth - \pal@outerbleed)\relax
      \ifdim\pal@rightwidth>\pal@leftwidth
        \ifnum#1=1
          \pal@leftpagefalse
          \pal@rightpagetrue
        \else
          \pal@leftpagetrue
          \pal@rightpagefalse
        \fi
        \addtocounter{page}{#1}
      \fi
    \fi
  \fi
}
\def\pal@textoptionbottom{bottom}
\def\pal@textoptioncenter{center}
\newif\ifpal@text@option@top
\newif\ifpal@text@option@center
\newif\ifpal@text@option@bottom
\newif\ifpal@text@option@parbox
\newif\ifpal@text@option@breakable
\let\originaltcbset\tcbset
\pgfkeys{
  /inittext/.is family,
  /inittext,
  color/.code={\color{#1}},
  coltext/.forward to=/inittext/color,
  boxrule/.code={\def\pal@defaultborderwidth{#1}\def\pal@text@option@leftrule{#1}\def\pal@text@option@rightrule{#1}\def\pal@text@option@toprule{#1}\def\pal@text@option@bottomrule{#1}},
  toprule/.code={\def\pal@text@option@toprule{#1}},
  rightrule/.code={\def\pal@text@option@rightrule{#1}},
  bottomrule/.code={\def\pal@text@option@bottomrule{#1}},
  leftrule/.code={\def\pal@text@option@leftrule{#1}},
  height/.code={\def\pal@text@option@height{#1}},
  arc/.code={\ifdim\pal@null=\dimexpr#1\relax\originaltcbset{outer arc=#1}\else\originaltcbset{auto outer arc}\fi\def\pal@defaultborderradius{#1}},
  colframe/.store in=\pal@defaultbordercolor,
  opacityframe/.store in=\pal@defaultborderopacity,
  breakable/.is if=pal@text@option@breakable,
  .unknown/.code=,
  library/.unknown/.code=,
}
\renewcommand\tcbset[1]{\originaltcbset{#1}\pgfkeys{inittext,#1}}
\tcbset{
  boxrule=0pt,
  boxsep=0pt,left=0pt,right=0pt,top=0pt,bottom=0pt,
  opacityframe=1,
  colframe=black,
  opacityback=0,
  arc=0pt,
}
\pgfkeysdef{/text/border}{
  \ifcsname pal@border@#1\endcsname
    \csname pal@border@#1\endcsname[1]{}
  \else
    \pgfkeys{textborder,opacity=1,width=0pt,color=black,radius=0pt}
    \pal@errmsg@undefined{border}{#1}
  \fi
}
\pgfkeys{
  /text/.is family,
  /text,
  name/.store in=\pal@text@option@name,
  color/.code={\originaltcbset{coltext=#1}\def\pal@text@option@color{#1}},
  opacity/.code={\originaltcbset{opacitytext=#1}},
  top/.code={\originaltcbset{valign=top}\pal@text@option@toptrue},
  center/.code={\originaltcbset{valign=center}\pal@text@option@centertrue},
  bottom/.code={\originaltcbset{valign=bottom}\pal@text@option@bottomtrue},
  boxrule/.code={\originaltcbset{boxrule=#1}\def\pal@defaultborderwidth{#1}\def\pal@text@option@leftrule{#1}\def\pal@text@option@rightrule{#1}\def\pal@text@option@toprule{#1}\def\pal@text@option@bottomrule{#1}},
  toprule/.code={\originaltcbset{toprule=#1}\def\pal@text@option@toprule{#1}},
  rightrule/.code={\originaltcbset{rightrule=#1}\def\pal@text@option@rightrule{#1}},
  bottomrule/.code={\originaltcbset{bottomrule=#1}\def\pal@text@option@bottomrule{#1}},
  leftrule/.code={\originaltcbset{leftrule=#1}\def\pal@text@option@leftrule{#1}},
  height/.code={\originaltcbset{height=#1}\def\pal@text@option@height{#1}},
  parbox/.is if=pal@text@option@parbox,
  breakable/.is if=pal@text@option@breakable,
  border radius/.code={\originaltcbset{arc=#1}\ifdim\pal@null=\dimexpr#1\relax\originaltcbset{outer arc=#1}\else\originaltcbset{auto outer arc}\fi\def\pal@defaultborderradius{#1}},
  arc/.forward to=/text/border radius,
  border width/.forward to=/text/boxrule,
  border color/.code={\originaltcbset{colframe=#1}\def\pal@defaultbordercolor{#1}},
  border opacity/.code={\originaltcbset{opacityframe=#1}\def\pal@defaultborderopacity{#1}},
  shadow/.forward to=/defaultshadow/name,
  shadow size/.forward to=/defaultshadow/size,
  shadow color/.forward to=/defaultshadow/color,
  shadow opacity/.forward to=/defaultshadow/opacity,
  shadow xshift/.forward to=/defaultshadow/xshift,
  shadow yshift/.forward to=/defaultshadow/yshift,
  .unknown/.code={\originaltcbset{\pgfkeyscurrentname=#1}}
}
\newdimen\pal@tcbheight
\newcommand\pal@puttext[5]{
  \ifpal@isbatchmode
  \else
    \pal@x=\posx{1}{#1}{1}{#2}
    \pal@xx=\posx{-1}{#3}{-1}{#4}
    \pal@y=\posy{-1}{#3}
    \pal@yy=\posy{1}{#1}

    \pal@xx=\dimexpr\pal@xx+\pal@text@option@rightrule\relax
    \pal@x=\dimexpr\pal@x-\pal@text@option@leftrule\relax
    \pal@yy=\dimexpr\pal@yy+\pal@text@option@toprule\relax
    \pal@y=\dimexpr\pal@y-\pal@text@option@bottomrule\relax

    \width=\dimexpr(\pal@xx - \pal@x)\relax
    \height=\dimexpr(\pal@yy - \pal@y)\relax
    \pal@textboxwidth=\dimexpr(\pal@xx - \pal@x)\relax
    \pal@textboxheight=\dimexpr(\pal@yy - \pal@y)\relax

    \ifdefined\pal@text@option@height
      \ifdim\pal@text@option@height=\height
      \else
        \pal@tcbheight=\dimexpr\pal@text@option@height\ifdefined\pal@text@option@toprule+\pal@text@option@toprule\else\ifdefined\pal@defaultborderwidth+\pal@defaultborderwidth\fi\fi\ifdefined\pal@text@option@bottomrule+\pal@text@option@bottomrule\else\ifdefined\pal@defaultborderwidth+\pal@defaultborderwidth\fi\fi\relax
        \originaltcbset{height=\pal@tcbheight}
      \fi
    \else
    \fi

    \pal@checkvisibility
    \ifpal@isvisible
      \pal@checkside{1}
      \ifpal@text@option@parbox
        \ifdim\pal@textboxheight<\pal@null
          \pal@yy=\dimexpr\pal@yy-\pal@textboxheight\relax
          \pal@textboxheight=\dimexpr-1\pal@textboxheight\relax
        \fi
        \put(\pal@dimentonumber{\pal@x},\pal@dimentonumber{\pal@yy}){%
          \parbox[t][\pal@textboxheight][\ifpal@text@option@center c\else\ifpal@text@option@bottom b\else t\fi\fi]{\pal@textboxwidth}{\vskip \pal@null
            \color{\pal@text@option@color}%
            #5%
          }
        }
      \else
        \ifdim\pal@text@option@bottomrule<\pal@text@option@toprule
          \def\pal@text@minvborderwidth{\pal@text@option@bottomrule}
          \def\pal@text@maxvborderwidth{\pal@text@option@toprule}
        \else
          \def\pal@text@minvborderwidth{\pal@text@option@toprule}
          \def\pal@text@maxvborderwidth{\pal@text@option@bottomrule}
        \fi
        \ifdim\pal@text@option@leftrule<\pal@text@option@rightrule
          \def\pal@text@minhborderwidth{\pal@text@option@leftrule}
          \def\pal@text@maxhborderwidth{\pal@text@option@rightrule}
        \else
          \def\pal@text@minhborderwidth{\pal@text@option@rightrule}
          \def\pal@text@maxhborderwidth{\pal@text@option@leftrule}
        \fi
        \ifdim\pal@text@minvborderwidth<\pal@text@minhborderwidth
          \def\pal@text@minborderwidth{\pal@text@minvborderwidth}
          \def\pal@text@maxborderwidth{\pal@text@maxhborderwidth}
        \else
          \def\pal@text@minborderwidth{\pal@text@minhborderwidth}
          \def\pal@text@maxborderwidth{\pal@text@maxvborderwidth}
        \fi
        \ifdim\pal@text@maxborderwidth=\pal@null
          \originaltcbset{opacityframe=0}
        \fi

        \ifpal@text@option@breakable
          \expandafter\xdef\csname pal@textarray@\pal@text@option@name @offsetx\endcsname{\pal@text@option@leftrule}
          \expandafter\xdef\csname pal@textarray@\pal@text@option@name @offsety\endcsname{\pal@text@option@bottomrule}
        \else
          \def\pal@text@option@name{pal@unbreakable}
        \fi
        \ifcsname pal@textarray@\pal@text@option@name @index\endcsname
          \global\expandafter\csname pal@textarray@\pal@text@option@name @index\endcsname 0 \relax%
          \boxarrayclear[\pal@text@option@name]
        \else
          \global\expandafter\newcount\csname pal@textarray@\pal@text@option@name @index\endcsname%
          \newboxarray{\pal@text@option@name}
        \fi
        \put(0,0){
          \ifpal@text@option@breakable%
            \begin{tcolorbox}[
              standard jigsaw,
              width=\width,
              enforce breakable,
              break at=\height,
              height fixed for=all,
              reset box array=\pal@text@option@name,
              store to box array=\pal@text@option@name,
            ]%
              #5
            \end{tcolorbox}%
          \else%
            \begin{tcolorbox}[
              standard jigsaw,
              width=\width,
              reset box array=\pal@text@option@name,
              store to box array=\pal@text@option@name,
            ]%
              #5
            \end{tcolorbox}%
          \fi%
        }
        \global\expandafter\advance\csname pal@textarray@\pal@text@option@name @index\endcsname by 1%

        \boxarraygetheight[\pal@text@option@name]{\pal@text@height}{1}
        \ifpal@text@option@bottom
          \pal@yy=\dimexpr\pal@yy-(\pal@textboxheight-\pal@text@height)\relax
        \else
          \ifpal@text@option@center
            \pal@yy=\dimexpr\pal@yy-(\pal@textboxheight-\pal@text@height)/2\relax
          \fi
        \fi
        \pal@textboxheight=\pal@text@height
        \pal@y=\dimexpr\pal@yy-\pal@textboxheight\relax

        % draw shadow
        \pal@ifshadow{
          \ifdefined\pal@defaultborderradius
            \ifdim\pal@defaultborderradius=0pt
              \pal@frameshadowradius=0pt
            \else
              \pal@frameshadowradius=\dimexpr\pal@defaultborderradius+\pal@text@minborderwidth\relax
            \fi
          \else
            \pal@frameshadowradius=0pt
          \fi

          \def\pal@frameshadowoffsetx{0pt}
          \def\pal@frameshadowoffsety{0pt}

          \def\pal@frameshadowwidth{\dimexpr\width+10cm\relax}
          \def\pal@frameshadowheight{\dimexpr\pal@textboxheight+10cm\relax}
          \def\pal@frameshadowframewidth{\width}
          \def\pal@frameshadowframeheight{\pal@textboxheight}
          \def\pal@frameshadowborder{\dimexpr5cm\relax}
          \ifpal@text@option@breakable
            \expandafter\xdef\csname pal@textarray@\pal@text@option@name @shadowsize\endcsname{\pal@defaultshadowsize}
            \expandafter\xdef\csname pal@textarray@\pal@text@option@name @shadowcolor\endcsname{\pal@defaultshadowcolor}
            \expandafter\xdef\csname pal@textarray@\pal@text@option@name @shadowopacity\endcsname{\pal@defaultshadowopacity}
            \expandafter\xdef\csname pal@textarray@\pal@text@option@name @shadowxshift\endcsname{\pal@defaultshadowxshift}
            \expandafter\xdef\csname pal@textarray@\pal@text@option@name @shadowyshift\endcsname{\pal@defaultshadowyshift}
            \expandafter\xdef\csname pal@textarray@\pal@text@option@name @frameshadowwidth\endcsname{\the\pal@frameshadowwidth}
            \expandafter\xdef\csname pal@textarray@\pal@text@option@name @frameshadowheight\endcsname{\the\pal@frameshadowheight}
            \expandafter\xdef\csname pal@textarray@\pal@text@option@name @frameshadowframewidth\endcsname{\the\pal@frameshadowframewidth}
            \expandafter\xdef\csname pal@textarray@\pal@text@option@name @frameshadowframeheight\endcsname{\the\pal@frameshadowframeheight}
            \expandafter\xdef\csname pal@textarray@\pal@text@option@name @frameshadowborder\endcsname{\the\pal@frameshadowborder}
            \expandafter\xdef\csname pal@textarray@\pal@text@option@name @frameshadowradius\endcsname{\the\pal@frameshadowradius}
          \fi
          \pal@drawshadow
        }

        \put(\pal@dimentonumber{\pal@x},\pal@dimentonumber{\pal@y}){%
          \consumeboxarray[\pal@text@option@name]{\the\csname pal@textarray@\pal@text@option@name @index\endcsname}%
        }
      \fi
      \pal@checkside{-1}
    \fi
  \fi
}
\newcommand\pal@putusetext[5][default]{
  \ifpal@isbatchmode
  \else
    \pal@x=\posx{1}{#2}{1}{#3}
    \pal@xx=\posx{-1}{#4}{-1}{#5}
    \pal@y=\posy{-1}{#4}
    \pal@yy=\posy{1}{#2}
    \width=\dimexpr(\pal@xx - \pal@x)\relax
    \height=\dimexpr(\pal@yy - \pal@y)\relax
    \pal@textboxwidth=\dimexpr(\pal@xx - \pal@x)\relax
    \pal@textboxheight=\dimexpr(\pal@yy - \pal@y)\relax

    \pal@checkvisibility
    \ifpal@isvisible
      \ifcsname pal@textarray@#1@index\endcsname
        \global\expandafter\advance\csname pal@textarray@#1@index\endcsname by 1%

        \pal@y=\dimexpr\pal@yy-\pal@textboxheight\relax

        \ifcsname pal@textarray@#1@shadowsize\endcsname
          \def\pal@frameshadowoffsetx{\expandafter\csname pal@textarray@#1@offsetx\endcsname}
          \def\pal@frameshadowoffsety{\expandafter\csname pal@textarray@#1@offsety\endcsname}

          \def\pal@frameshadowwidth{\dimexpr\expandafter\csname pal@textarray@#1@frameshadowwidth\endcsname\relax}
          \def\pal@frameshadowheight{\dimexpr\expandafter\csname pal@textarray@#1@frameshadowheight\endcsname\relax}
          \def\pal@frameshadowframewidth{\dimexpr\expandafter\csname pal@textarray@#1@frameshadowframewidth\endcsname\relax}
          \def\pal@frameshadowframeheight{\dimexpr\expandafter\csname pal@textarray@#1@frameshadowframeheight\endcsname\relax}
          \def\pal@frameshadowborder{\dimexpr\expandafter\csname pal@textarray@#1@frameshadowborder\endcsname\relax}
          \def\pal@frameshadowradius{\dimexpr\expandafter\csname pal@textarray@#1@frameshadowradius\endcsname\relax}

          \def\pal@defaultshadowsize{\expandafter\csname pal@textarray@#1@shadowsize\endcsname}
          \def\pal@defaultshadowcolor{\expandafter\csname pal@textarray@#1@shadowcolor\endcsname}
          \def\pal@defaultshadowopacity{\expandafter\csname pal@textarray@#1@shadowopacity\endcsname}
          \def\pal@defaultshadowxshift{\dimexpr\expandafter\csname pal@textarray@#1@shadowxshift\endcsname\relax}
          \def\pal@defaultshadowyshift{\dimexpr\expandafter\csname pal@textarray@#1@shadowyshift\endcsname\relax}

          \pal@drawshadow
        \fi

        \pal@checkside{1}
        \put(\pal@dimentonumber{\pal@x-\expandafter\csname pal@textarray@#1@offsetx\endcsname},\pal@dimentonumber{\pal@y-\expandafter\csname pal@textarray@#1@offsety\endcsname}){%
          \consumeboxarray[#1]{\the\csname pal@textarray@#1@index\endcsname}%
        }
        \pal@checkside{-1}
      \else
        \pal@errmsg@undefined{breakable text}{#1}
      \fi
    \fi
  \fi
}

% xput
\newcommand\pal@putxput[6][0]{
  \pal@x=\posx{1}{#2}{1}{#3}
  \pal@xx=\posx{-1}{#4}{-1}{#5}
  \pal@y=\posy{-1}{#4}
  \pal@yy=\posy{1}{#2}

  \pal@checkvisibility
  \ifpal@isvisible
    \ifnum#1=1
      \pal@snapsafezonehorizontal
      \pal@snapsafezonevertical
    \fi

    \width=\dimexpr(\pal@xx - \pal@x)\relax
    \height=\dimexpr(\pal@yy - \pal@y)\relax

    \put(\pal@dimentonumber{\pal@x},\pal@dimentonumber{\pal@y}){%
      \ifx\pal@pageoptioncolor\pal@emptystring
        \color{\paloptions@color}%
      \else
        \color{\pal@pageoptioncolor}%
      \fi
      #6
    }
  \fi
}

% tikzgraphic
\newcommand\pal@puttikz[6][0]{
  \ifpal@isbatchmode
  \else
    \pal@putxput[#1]{#2}{#3}{#4}{#5}{%
      \begin{tikzpicture}
        \pgflowlevelsynccm
        #6
      \end{tikzpicture}
    }
  \fi
}

% border
\def\pal@defaultborderwidth{0pt}
\def\pal@defaultborderradius{0pt}
\def\pal@defaultbordercolor{black}
\def\pal@defaultborderopacity{1}
\pgfkeysdef{/defaultborder/name}{
  \ifcsname pal@border@#1\endcsname
    \csname pal@border@#1\endcsname{}
  \else
    \pgfkeys{defaultborder,opacity=1,width=0pt,color=black,radius=0pt}
    \pal@errmsg@undefined{border}{#1}
  \fi
}
\newcommand\newborder[2]{
  \expandafter\newcommand\csname pal@border@#1\endcsname[2][0]{%
    \ifnum##1=1
      \pgfkeys{textborder,opacity=1,width=0pt,color=black,radius=0pt,#2}
    \else
      \pgfkeys{defaultborder,opacity=1,width=0pt,color=black,radius=0pt,#2,##2}
    \fi
  }%
}
\pgfkeys{
  /textborder/.is family,
  /textborder,
  radius/.forward to=/text/border radius,
  width/.forward to=/text/border width,
  color/.forward to=/text/border color,
  opacity/.forward to=/text/border opacity,
}
\pgfkeys{
  /defaultborder/.is family,
  /defaultborder,
  radius/.store in=\pal@defaultborderradius,
  width/.store in=\pal@defaultborderwidth,
  color/.store in=\pal@defaultbordercolor,
  opacity/.store in=\pal@defaultborderopacity,
}
\newcommand\setborder[2][]{
  \ifpal@placeholdermode
    \ifnum\pal@contentcounter<\pal@placeholdercounter
      \pal@border{#1}{#2}
    \fi
  \else
    \pal@border{#1}{#2}
  \fi
}
\def\noborder{\setborder{}}
\newcommand\pal@border[2]{
  \pgfkeys{defaultborder,width=0pt,color=black,opacity=1,radius=0pt,#1}
  \ifcsname pal@border@#2\endcsname
    \csname pal@border@#2\endcsname{#1}
  \fi
}

% shadow
\def\pal@defaultshadowsize{0}
\def\pal@defaultshadowopacity{0.4}
\def\pal@defaultshadowcolor{black}
\def\pal@defaultshadowxshift{0pt}
\def\pal@defaultshadowyshift{0pt}
\pgfkeysdef{/defaultshadow/name}{
  \ifcsname pal@shadow@#1\endcsname
    \csname pal@shadow@#1\endcsname{}
  \else
    \pgfkeys{defaultshadow,size=0,color=black,opacity=0.4,xshift=0pt,yshift=0pt}
    \pal@errmsg@undefined{shadow}{#1}
  \fi
}
\newcommand\newshadow[2]{
  \expandafter\newcommand\csname pal@shadow@#1\endcsname[1]{%
    \pgfkeys{defaultshadow,size=0,color=black,opacity=0.4,xshift=0pt,yshift=0pt,#2,##1}
  }%
}
\pgfkeys{
  /defaultshadow/.is family,
  /defaultshadow,
  size/.store in=\pal@defaultshadowsize,
  color/.store in=\pal@defaultshadowcolor,
  opacity/.store in=\pal@defaultshadowopacity,
  xshift/.store in=\pal@defaultshadowxshift,
  yshift/.store in=\pal@defaultshadowyshift,
}
\newcommand\setshadow[2][]{
  \ifpal@placeholdermode
    \ifnum\pal@contentcounter<\pal@placeholdercounter
      \pal@shadow{#1}{#2}
    \fi
  \else
    \pal@shadow{#1}{#2}
  \fi
}
\def\noshadow{\setshadow{}}
\newcommand\pal@shadow[2]{
  \pgfkeys{defaultshadow,size=0,color=black,opacity=0.4,xshift=0pt,yshift=0pt,#1}
  \ifcsname pal@shadow@#2\endcsname
    \csname pal@shadow@#2\endcsname{#1}
  \fi
}
\newcommand\pal@ifshadow[1]{
  \ifdim\dimexpr\pal@defaultshadowsize pt\relax>\pal@null
    #1
  \else
    \ifdim\pal@defaultshadowxshift>\pal@null
      #1
    \else
      \ifdim\pal@defaultshadowyshift>\pal@null
        #1
      \fi
    \fi
  \fi
}
\def\pal@drawshadow{
  \pal@ifshadow{
    \xdef\pal@shadowid{shadow-\pal@defaultshadowsize-\pal@defaultshadowcolor-\pal@defaultshadowopacity-\the\numexpr\pal@frameshadowwidth\relax-\the\numexpr\pal@frameshadowheight\relax-\the\numexpr\pal@frameshadowradius\relax-\the\numexpr\pal@frameshadowborder\relax}
    \IfFileExists{./cache/\pal@shadowid/s.pdf}{
    \put(\pal@dimentonumber{\dimexpr\pal@x-5cm-\pal@frameshadowoffsetx+\pal@defaultshadowxshift\relax},\pal@dimentonumber{\dimexpr\pal@y-5cm-\pal@frameshadowoffsety-\pal@defaultshadowyshift\relax}){%
      \includegraphics[width=\pal@frameshadowwidth]{cache/\pal@shadowid/s.pdf}
    }
    }{
      \pal@makeshadow{\pal@shadowid}
      \IfFileExists{./cache/\pal@shadowid/s.pdf}{
      \put(\pal@dimentonumber{\dimexpr\pal@x-5cm-\pal@frameshadowoffsetx+\pal@defaultshadowxshift\relax},\pal@dimentonumber{\dimexpr\pal@y-5cm-\pal@frameshadowoffsety-\pal@defaultshadowyshift\relax}){%
        \includegraphics[width=\pal@frameshadowwidth]{cache/\pal@shadowid/s.pdf}
      }
      }{
        \ifx\pal@processresult\pal@ok
          \ClassError{pagelayout}{Unexpected error. Shadow not created}{File `cache/\pal@shadowid/s.pdf' not\MessageBreak found.\MessageBreak\MessageBreak\@ehc}
        \fi
      }
    }
  }
}

% layout helper
\def\pal@gridcolor{green!90!black}
\def\pal@gridopacity{0.8}
\def\pal@gutteropacity{0.2}
\newdimen\pal@gridx
\newdimen\pal@gridxx
\newdimen\pal@gridy
\newdimen\pal@gridyy
\newcommand\pal@putgrid{
  \ifpal@isemptypage
  \else
    \ifpal@grid
      \pal@gridx=\posx{1}{1}{1}{0}
      \pal@gridxx=\posx{-1}{1}{-1}{\pal@get{1C}}
      \pal@gridy=\posy{1}{0}
      \pal@gridyy=\posy{-1}{\pal@rowscount}
      \put(0,0){%
        \begin{tikzpicture}%
          \pgflowlevelsynccm%
          \foreach \rowI in {1,...,\pal@rowscount} {
            \ifnum\rowI<\pal@rowscount
              \ifdim\pal@gutter=\pal@null
                \draw[line cap=rect,line width=0.2mm,draw=\pal@gridcolor,opacity=\pal@gridopacity] ({\pal@gridx+0.05mm},{\posy{0}{\rowI}}) -- ({\pal@gridxx-0.05mm},{\posy{0}{\rowI}});%
              \else
                \draw[line cap=rect,line width=\pal@gutter,draw=\pal@gridcolor,opacity=\pal@gutteropacity] ({\pal@gridx+\pal@gutter/2},{\posy{0}{\rowI}}) -- ({\pal@gridxx-\pal@gutter/2},{\posy{0}{\rowI}});%
              \fi
            \fi
            \ifnum\numexpr\pal@get{\rowI C} - 1\relax>0
              \foreach \cellI in {1,...,\numexpr\pal@get{\rowI C} - 1\relax} {
                \ifdim\pal@gutter=\pal@null
                  \draw[line width=0.2mm,draw=\pal@gridcolor,opacity=\pal@gridopacity] ({\posx{-1}{\rowI}{0}{\cellI}},{\posy{1}{\numexpr\rowI - 1\relax}}) -- ({\posx{-1}{\rowI}{0}{\cellI}},{\posy{-1}{\rowI}});%
                \else
                  \draw[line width=\pal@gutter,draw=\pal@gridcolor,opacity=\pal@gutteropacity] ({\posx{-1}{\rowI}{0}{\cellI}},{\posy{1}{\numexpr\rowI - 1\relax}}) -- ({\posx{-1}{\rowI}{0}{\cellI}},{\posy{-1}{\rowI}});%
                \fi
              }
            \fi
          }
          \draw[line width=0.2mm,draw=\pal@gridcolor,opacity=\pal@gridopacity] ({\pal@gridx},{\pal@gridy}) rectangle ({\pal@gridxx},{\pal@gridyy});%
          \ifdim\pal@gridoffsethorizontal>0.001pt
            \draw[line width=0.2mm,dash pattern={on 1mm off 1mm},draw=\pal@gridcolor,opacity=\pal@gridopacity] (\pal@gridx,\pal@gridy) -- (\pal@gridx-\pal@gridoffsethorizontal,\pal@gridy) -- (\pal@gridx-\pal@gridoffsethorizontal,\pal@gridyy) -- (\pal@gridx,\pal@gridyy);%
          \fi
          \ifdim\pal@gridoffsethorizontaln>0.001pt
            \draw[line width=0.2mm,dash pattern={on 1mm off 1mm},draw=\pal@gridcolor,opacity=\pal@gridopacity] (\pal@gridxx,\pal@gridy) -- (\pal@gridxx+\pal@gridoffsethorizontaln,\pal@gridy) -- (\pal@gridxx+\pal@gridoffsethorizontaln,\pal@gridyy) -- (\pal@gridxx,\pal@gridyy);%
          \fi
          \ifdim\pal@gridoffsetvertical>0.001pt
            \draw[line width=0.2mm,dash pattern={on 1mm off 1mm},draw=\pal@gridcolor,opacity=\pal@gridopacity]  (\pal@gridx,\pal@gridy) -- (\pal@gridx,\pal@gridy+\pal@gridoffsetvertical)-- (\pal@gridxx,\pal@gridy+\pal@gridoffsetvertical) -- (\pal@gridxx,\pal@gridy);%
          \fi
          \ifdim\pal@gridoffsetverticaln>0.001pt
            \draw[line width=0.2mm,dash pattern={on 1mm off 1mm},draw=\pal@gridcolor,opacity=\pal@gridopacity] ({\pal@gridx},{\pal@gridyy}) --({\pal@gridx},{\pal@gridyy-\pal@gridoffsetverticaln}) -- ({\pal@gridxx},{\pal@gridyy-\pal@gridoffsetverticaln}) -- ({\pal@gridxx},{\pal@gridyy});%
          \fi
        \end{tikzpicture}%
      }
    \fi
  \fi
}
\def\pal@bleedcolor{red}
\def\pal@bleedopacity{0.5}
\newif\ifpal@putbleed
\newcommand\pal@checkbleed{
  \ifdim\pal@topbleed>\pal@null
    \pal@putbleedtrue
  \else
    \ifdim\pal@bottombleed>\pal@null
      \pal@putbleedtrue
    \else
      \ifdim\pal@innerbleed>\pal@null
        \pal@putbleedtrue
      \else
        \ifdim\pal@outerbleed>\pal@null
          \pal@putbleedtrue
        \else
          \pal@putbleedfalse
        \fi
      \fi
    \fi
  \fi
}
\newcommand\pal@putbleed{
  \ifpal@isemptypage
  \else
    \ifpal@safezone
      \pal@checkbleed
      \ifpal@putbleed
        \put(0,0){%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%

            \ifpal@frontcover
              \ifpal@backcover
                \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (0, \pal@pageheight + \pal@bottombleed) rectangle ++(\pal@pagewidth + \pal@outerbleed,\pal@topbleed);%
                \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (0, 0) rectangle ++(\pal@pagewidth + \pal@outerbleed,\pal@bottombleed);%
                \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (0, \pal@bottombleed) rectangle ++(\pal@outerbleed,\pal@pageheight);%
              \else
                \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (\pal@pagewidth + \pal@outerbleed, \pal@pageheight + \pal@bottombleed) rectangle ++(\pal@pagewidth + \pal@outerbleed + \spinewidth,\pal@topbleed);%
                \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (\pal@pagewidth + \pal@outerbleed, 0) rectangle ++(\pal@pagewidth + \pal@outerbleed + \spinewidth,\pal@bottombleed);%
                \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (\pal@pagewidth * 2 + \pal@outerbleed + \spinewidth, \pal@bottombleed) rectangle ++(\pal@outerbleed,\pal@pageheight);%
              \fi
            \else
              \ifpal@fanfold
                \ifpal@isdoublepage
                  \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (0, \pal@pageheight + \pal@bottombleed) rectangle ++(\pal@pagewidth * 2 + \pal@outerbleed * 2,\pal@topbleed);%
                  \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (0, 0) rectangle ++(\pal@pagewidth * 2 + \pal@outerbleed * 2,\pal@bottombleed);%
                  \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (0, \pal@bottombleed) rectangle ++(\pal@outerbleed,\pal@pageheight);%
                  \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (\pal@pagewidth * 2 + \pal@outerbleed, \pal@bottombleed) rectangle ++(\pal@outerbleed,\pal@pageheight);%
                \else
                  \ifpal@leftpage
                    \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (0, \pal@pageheight + \pal@bottombleed) rectangle ++(\pal@pagewidth + \pal@outerbleed,\pal@topbleed);%
                    \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (0, 0) rectangle ++(\pal@pagewidth + \pal@outerbleed,\pal@bottombleed);%
                    \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (0, \pal@bottombleed) rectangle ++(\pal@outerbleed,\pal@pageheight);%
                  \else
                    \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (\pal@pagewidth + \pal@outerbleed, \pal@pageheight + \pal@bottombleed) rectangle ++(\pal@pagewidth + \pal@outerbleed,\pal@topbleed);%
                    \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (\pal@pagewidth + \pal@outerbleed, 0) rectangle ++(\pal@pagewidth + \pal@outerbleed,\pal@bottombleed);%
                    \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (\pal@pagewidth * 2 + \pal@outerbleed, \pal@bottombleed) rectangle ++(\pal@outerbleed,\pal@pageheight);%
                  \fi
                \fi
              \else
                \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (0, \pal@pageheight + \pal@bottombleed) rectangle ++(\pal@pagewidth + \pal@leftbleed + \pal@rightbleed,\pal@topbleed);%
                \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (0, 0) rectangle ++(\pal@pagewidth + \pal@leftbleed + \pal@rightbleed,\pal@bottombleed);%
                \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (0, \pal@bottombleed) rectangle ++(\pal@leftbleed,\pal@pageheight);%
                \fill[\pal@bleedcolor,opacity=\pal@bleedopacity] (\pal@pagewidth + \pal@leftbleed, \pal@bottombleed) rectangle ++(\pal@rightbleed,\pal@pageheight);%
              \fi
            \fi
          \end{tikzpicture}%
        }
      \fi
    \fi
  \fi
}
\newdimen\pal@cuttingmarka
\newdimen\pal@cuttingmarkb
\pal@cuttingmarka=-3mm
\pal@cuttingmarkb=-1mm
\newcommand\pal@putcuttingmarks{
  \ifpal@isemptypage
    \ifpal@fanfold
      \pal@cuttingmarksvisibletrue
    \fi
  \else
    \pal@cuttingmarksvisibletrue
  \fi
  \ifpal@cuttingmarksvisible
    \ifpal@cuttingmarks
      \ifpal@safezone
      \else
        \pal@checkbleed
        \ifpal@putbleed
          \put(0,0){%
            \begin{tikzpicture}%
              \pgflowlevelsynccm%

              \ifpal@frontcover
                \ifpal@backcover
                  \draw[\pal@pageoptioncolor,line width=0.15mm](\pal@outerbleed + \pal@cuttingmarka, \pal@bottombleed) -- (\pal@outerbleed + \pal@cuttingmarkb, \pal@bottombleed);%
                  \draw[\pal@pageoptioncolor,line width=0.15mm](\pal@outerbleed, \pal@bottombleed + \pal@cuttingmarka) -- (\pal@outerbleed, \pal@bottombleed + \pal@cuttingmarkb);%
                  \draw[\pal@pageoptioncolor](\pal@outerbleed + \pal@cuttingmarka, \pal@bottombleed+\pal@pageheight) -- (\pal@outerbleed + \pal@cuttingmarkb, \pal@bottombleed + \pal@pageheight);%
                  \draw[\pal@pageoptioncolor](\pal@outerbleed, \pal@bottombleed + \pal@pageheight - \pal@cuttingmarka) -- (\pal@outerbleed, \pal@bottombleed + \pal@pageheight - \pal@cuttingmarkb);%
                \else
                  \draw[\pal@pageoptioncolor](2\pal@pagewidth + \pal@outerbleed + \spinewidth - \pal@cuttingmarka, \pal@bottombleed) -- (2\pal@pagewidth + \pal@outerbleed + \spinewidth - \pal@cuttingmarkb, \pal@bottombleed);%
                  \draw[\pal@pageoptioncolor](2\pal@pagewidth + \pal@outerbleed + \spinewidth, \pal@bottombleed + \pal@cuttingmarka) -- (2\pal@pagewidth + \pal@outerbleed + \spinewidth, \pal@bottombleed + \pal@cuttingmarkb);%
                  \draw[\pal@pageoptioncolor](2\pal@pagewidth + \pal@outerbleed + \spinewidth - \pal@cuttingmarka, \pal@bottombleed+\pal@pageheight) -- (2\pal@pagewidth + \pal@outerbleed + \spinewidth - \pal@cuttingmarkb, \pal@bottombleed+\pal@pageheight);%
                  \draw[\pal@pageoptioncolor](2\pal@pagewidth + \pal@outerbleed + \spinewidth, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarka) -- (2\pal@pagewidth + \pal@outerbleed + \spinewidth, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarkb);%
                \fi
              \else
                \ifpal@fanfold
                  \ifpal@isdoublepage
                    \draw[\pal@pageoptioncolor](\pal@outerbleed + \pal@cuttingmarka, \pal@bottombleed) -- (\pal@outerbleed + \pal@cuttingmarkb, \pal@bottombleed);%
                    \draw[\pal@pageoptioncolor](\pal@outerbleed, \pal@bottombleed + \pal@cuttingmarka) -- (\pal@outerbleed, \pal@bottombleed + \pal@cuttingmarkb);%
                    \draw[\pal@pageoptioncolor](\pal@outerbleed + \pal@cuttingmarka, \pal@bottombleed+\pal@pageheight) -- (\pal@outerbleed + \pal@cuttingmarkb, \pal@bottombleed+\pal@pageheight);%
                    \draw[\pal@pageoptioncolor](\pal@outerbleed, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarka) -- (\pal@outerbleed, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarkb);%

                    \draw[\pal@pageoptioncolor](2\pal@pagewidth + \pal@outerbleed - \pal@cuttingmarka, \pal@bottombleed) -- (2\pal@pagewidth + \pal@outerbleed - \pal@cuttingmarkb, \pal@bottombleed);%
                    \draw[\pal@pageoptioncolor](2\pal@pagewidth + \pal@outerbleed, \pal@bottombleed + \pal@cuttingmarka) -- (2\pal@pagewidth + \pal@outerbleed, \pal@bottombleed + \pal@cuttingmarkb);%
                    \draw[\pal@pageoptioncolor](2\pal@pagewidth + \pal@outerbleed - \pal@cuttingmarka, \pal@bottombleed+\pal@pageheight) -- (2\pal@pagewidth + \pal@outerbleed - \pal@cuttingmarkb, \pal@bottombleed+\pal@pageheight);%
                    \draw[\pal@pageoptioncolor](2\pal@pagewidth + \pal@outerbleed, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarka) -- (2\pal@pagewidth + \pal@outerbleed, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarkb);%
                  \else
                    \ifpal@leftpage
                      \draw[\pal@pageoptioncolor](\pal@outerbleed + \pal@cuttingmarka, \pal@bottombleed) -- (\pal@outerbleed + \pal@cuttingmarkb, \pal@bottombleed);%
                      \draw[\pal@pageoptioncolor](\pal@outerbleed, \pal@bottombleed + \pal@cuttingmarka) -- (\pal@outerbleed, \pal@bottombleed + \pal@cuttingmarkb);%
                      \draw[\pal@pageoptioncolor](\pal@outerbleed + \pal@cuttingmarka, \pal@bottombleed+\pal@pageheight) -- (\pal@outerbleed + \pal@cuttingmarkb, \pal@bottombleed+\pal@pageheight);%
                      \draw[\pal@pageoptioncolor](\pal@outerbleed, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarka) -- (\pal@outerbleed, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarkb);%
                    \else
                      \draw[\pal@pageoptioncolor](2\pal@pagewidth + \pal@outerbleed - \pal@cuttingmarka, \pal@bottombleed) -- (2\pal@pagewidth + \pal@outerbleed - \pal@cuttingmarkb, \pal@bottombleed);%
                      \draw[\pal@pageoptioncolor](2\pal@pagewidth + \pal@outerbleed, \pal@bottombleed + \pal@cuttingmarka) -- (2\pal@pagewidth + \pal@outerbleed, \pal@bottombleed + \pal@cuttingmarkb);%
                      \draw[\pal@pageoptioncolor](2\pal@pagewidth + \pal@outerbleed - \pal@cuttingmarka, \pal@bottombleed+\pal@pageheight) -- (2\pal@pagewidth + \pal@outerbleed - \pal@cuttingmarkb, \pal@bottombleed+\pal@pageheight);%
                      \draw[\pal@pageoptioncolor](2\pal@pagewidth + \pal@outerbleed, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarka) -- (2\pal@pagewidth + \pal@outerbleed, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarkb);%
                    \fi
                  \fi
                \else
                  \draw[\pal@pageoptioncolor](\pal@outerbleed + \pal@cuttingmarka, \pal@bottombleed) -- (\pal@outerbleed + \pal@cuttingmarkb, \pal@bottombleed);%
                  \draw[\pal@pageoptioncolor](\pal@outerbleed, \pal@bottombleed + \pal@cuttingmarka) -- (\pal@outerbleed, \pal@bottombleed + \pal@cuttingmarkb);%
                  \draw[\pal@pageoptioncolor](\pal@outerbleed + \pal@cuttingmarka, \pal@bottombleed+\pal@pageheight) -- (\pal@outerbleed + \pal@cuttingmarkb, \pal@bottombleed+\pal@pageheight);%
                  \draw[\pal@pageoptioncolor](\pal@outerbleed, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarka) -- (\pal@outerbleed, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarkb);%
                  \draw[\pal@pageoptioncolor](\pal@pagewidth + \pal@outerbleed - \pal@cuttingmarka, \pal@bottombleed) -- (\pal@pagewidth + \pal@outerbleed - \pal@cuttingmarkb, \pal@bottombleed);%
                  \draw[\pal@pageoptioncolor](\pal@pagewidth + \pal@outerbleed, \pal@bottombleed + \pal@cuttingmarka) -- (\pal@pagewidth + \pal@outerbleed, \pal@bottombleed + \pal@cuttingmarkb);%
                  \draw[\pal@pageoptioncolor](\pal@pagewidth + \pal@outerbleed - \pal@cuttingmarka, \pal@bottombleed+\pal@pageheight) -- (\pal@pagewidth + \pal@outerbleed - \pal@cuttingmarkb, \pal@bottombleed+\pal@pageheight);%
                  \draw[\pal@pageoptioncolor](\pal@pagewidth + \pal@outerbleed, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarka) -- (\pal@pagewidth + \pal@outerbleed, \pal@bottombleed+\pal@pageheight - \pal@cuttingmarkb);%
                \fi
              \fi
            \end{tikzpicture}%
          }
        \fi
      \fi
    \fi
  \fi
}
\def\pal@safetymargincolor{pink}
\def\pal@safetymarginopacity{0.8}
\newif\ifpal@putsafezone
\newcommand\pal@checksafezone{
  \ifdim\pal@topsafetymargin>\pal@null
    \pal@putsafezonetrue
  \else
    \ifdim\pal@bottomsafetymargin>\pal@null
      \pal@putsafezonetrue
    \else
      \ifdim\pal@innersafetymargin>\pal@null
        \pal@putsafezonetrue
      \else
        \ifdim\pal@outersafetymargin>\pal@null
          \pal@putsafezonetrue
        \else
          \pal@putsafezonefalse
        \fi
      \fi
    \fi
  \fi
}
\newcommand\pal@putsafezone{
  \ifpal@isemptypage
  \else
    \ifpal@safezone
      \pal@checksafezone
      \ifpal@putsafezone
        \put(0,0){%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%

            \ifpal@frontcover
              \ifpal@backcover
              \else
                \draw[line cap=rect,line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\pal@pagewidth + \pal@outerbleed,0.05mm) -- (\pal@pagewidth + \pal@outerbleed,\paperheight-0.05mm);%
                \draw[line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\pal@outersafetymargin + \pal@outerbleed,\pal@bottomsafetymargin + \pal@bottombleed) rectangle (\pal@pagewidth + \pal@outerbleed - \pal@innersafetymargin,\paperheight - \pal@topsafetymargin - \pal@topbleed);%
                \draw[line cap=rect,line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\pal@pagewidth + \pal@outerbleed + \spinewidth,0.05mm) -- (\pal@pagewidth + \pal@outerbleed + \spinewidth,\paperheight-0.05mm);%
                \draw[line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\pal@pagewidth + \pal@outerbleed + \spinewidth + \pal@innersafetymargin,\pal@bottomsafetymargin + \pal@bottombleed) rectangle (\paperwidth - \pal@outerbleed - \pal@outersafetymargin,\paperheight - \pal@topsafetymargin - \pal@topbleed);%
              \fi
            \else
              \ifpal@fanfold
                \ifpal@isdoublepage
                  \draw[line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\pal@outersafetymargin + \pal@outerbleed,\pal@bottomsafetymargin + \pal@bottombleed) rectangle (\paperwidth / 2 - \pal@innersafetymargin,\paperheight - \pal@topsafetymargin - \pal@topbleed);%
                  \draw[line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\paperwidth / 2 + \pal@innersafetymargin,\pal@bottomsafetymargin + \pal@bottombleed) rectangle (\paperwidth - \pal@outerbleed - \pal@outersafetymargin,\paperheight - \pal@topsafetymargin - \pal@topbleed);%
                \else
                  \ifpal@leftpage
                    \draw[line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\pal@outersafetymargin + \pal@outerbleed,\pal@bottomsafetymargin + \pal@bottombleed) rectangle (\paperwidth / 2 - \pal@innersafetymargin,\paperheight - \pal@topsafetymargin - \pal@topbleed);%
                  \else
                    \draw[line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\paperwidth / 2 + \pal@innersafetymargin,\pal@bottomsafetymargin + \pal@bottombleed) rectangle (\paperwidth - \pal@outerbleed - \pal@outersafetymargin,\paperheight - \pal@topsafetymargin - \pal@topbleed);%
                  \fi
                \fi
                \draw[line cap=rect,line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\paperwidth / 2,0.05mm) -- (\paperwidth / 2,\paperheight-0.05mm);%
              \else
                \draw[line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\pal@leftsafetymargin + \pal@leftbleed,\pal@bottomsafetymargin + \pal@bottombleed) rectangle (\paperwidth - \pal@rightsafetymargin - \pal@rightbleed,\paperheight - \pal@topsafetymargin - \pal@topbleed);%
              \fi
            \fi
          \end{tikzpicture}%
        }
      \else
        \ifpal@frontcover
          \ifpal@backcover
          \else
            \put(0,0){%
              \begin{tikzpicture}%
                \pgflowlevelsynccm%
                \draw[line cap=rect,line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\pal@pagewidth + \pal@outerbleed,0.05mm) -- (\pal@pagewidth + \pal@outerbleed,\paperheight-0.05mm);%
                \draw[line cap=rect,line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\pal@pagewidth + \pal@outerbleed + \spinewidth,0.05mm) -- (\pal@pagewidth + \pal@outerbleed + \spinewidth,\paperheight-0.05mm);%
              \end{tikzpicture}%
            }
          \fi
        \else
          \ifpal@fanfold
            \put(0,0){%
              \begin{tikzpicture}%
                \pgflowlevelsynccm%
                \draw[line cap=rect,line width=0.1mm,draw=\pal@safetymargincolor,opacity=\pal@safetymarginopacity] (\paperwidth / 2,0.05mm) -- (\paperwidth / 2,\paperheight-0.05mm);%
              \end{tikzpicture}%
            }
          \fi
        \fi
      \fi
    \fi
  \fi
}
\def\pal@graphpapercolor{gray!70}
\def\pal@graphpaperopacity{0.2}
\newcommand\pal@calcgraphpaperx{
  \ifdim\pal@graphpaperx>\pal@null
    \pal@graphpaperx=\dimexpr\pal@graphpaperx-\pal@graphpapersnap\relax
    \pal@calcgraphpaperx
  \fi
}
\newcommand\pal@calcgraphpapery{
  \ifdim\pal@graphpapery>\pal@null
    \pal@graphpapery=\dimexpr\pal@graphpapery-\pal@graphpapersnap\relax
    \pal@calcgraphpapery
  \fi
}
\newcommand\pal@calcgraphpaperoffset{
  \pal@graphpaperoffset=\pal@null

  \pal@graphpaperoffsetsnap \numexpr\number\pal@pagewidth/\pal@graphpapersnap\relax
  \pal@graphpaperoffset=\dimexpr\pal@pagewidth-\pal@graphpapersnap*\pal@graphpaperoffsetsnap\relax
  \ifdim\pal@graphpaperoffset<\pal@null
    \pal@graphpaperoffset=\dimexpr\pal@graphpaperoffset+\pal@graphpapersnap\relax
  \fi
  \pal@graphpaperx=\dimexpr\pal@graphpaperx-\pal@graphpaperoffset\relax
}
\newcount\pal@graphpaperoffsetsnap
\newcommand\pal@putgraphpaper{
  \ifpal@graphpaper
    \pal@graphpapery=\pal@bottombleed
    \pal@calcgraphpapery
    \pal@graphpaperx=\pal@leftbleed
    \pal@calcgraphpaperx

    \ifpal@frontcover
      \ifpal@backcover
        \put(\pal@dimentonumber{\pal@graphpaperx},\pal@dimentonumber{\pal@graphpapery}){%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%

            \foreach \pal@graphpaperconfigitem in \pal@graphpaperconfig {
              \draw[line cap=rect,line width=0.05mm,step=\pal@graphpaperconfigitem,\pal@graphpapercolor,opacity=\pal@graphpaperopacity] (0pt,0pt) grid ++(\pal@pagewidth-\pal@graphpaperx+\pal@outerbleed,\paperheight-\pal@graphpapery);%
            }
          \end{tikzpicture}%
        }
      \else
        \pal@graphpaperx=\dimexpr\pal@pagewidth+\pal@outerbleed\relax
        \put(\pal@dimentonumber{\pal@graphpaperx},\pal@dimentonumber{\pal@graphpapery}){%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%

            \foreach \pal@graphpaperconfigitem in \pal@graphpaperconfig {
              \draw[line cap=rect,line width=0.05mm,step=\pal@graphpaperconfigitem,\pal@graphpapercolor,opacity=\pal@graphpaperopacity] (0pt,0pt) grid ++(\spinewidth,\paperheight-\pal@graphpapery);%
            }
          \end{tikzpicture}%
        }
        \pal@graphpaperx=\dimexpr\pal@pagewidth+\pal@outerbleed+\spinewidth\relax
        \put(\pal@dimentonumber{\pal@graphpaperx},\pal@dimentonumber{\pal@graphpapery}){%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%

            \foreach \pal@graphpaperconfigitem in \pal@graphpaperconfig {
              \draw[line cap=rect,line width=0.05mm,step=\pal@graphpaperconfigitem,\pal@graphpapercolor,opacity=\pal@graphpaperopacity] (0pt,0pt) grid ++(\pal@pagewidth+\pal@outerbleed,\paperheight-\pal@graphpapery);%
            }
          \end{tikzpicture}%
        }
      \fi
    \else
      \ifpal@fanfold
        \ifpal@isdoublepage
          \put(\pal@dimentonumber{\pal@graphpaperx},\pal@dimentonumber{\pal@graphpapery}){%
            \begin{tikzpicture}%
              \pgflowlevelsynccm%

              \foreach \pal@graphpaperconfigitem in \pal@graphpaperconfig {
                \draw[line cap=rect,line width=0.05mm,step=\pal@graphpaperconfigitem,\pal@graphpapercolor,opacity=\pal@graphpaperopacity] (0pt,0pt) grid ++(\paperwidth-\pal@graphpaperx,\paperheight-\pal@graphpapery);%
              }
            \end{tikzpicture}%
          }
        \else
          \ifpal@leftpage
            \put(\pal@dimentonumber{\pal@graphpaperx},\pal@dimentonumber{\pal@graphpapery}){%
              \begin{tikzpicture}%
                \pgflowlevelsynccm%

                \foreach \pal@graphpaperconfigitem in \pal@graphpaperconfig {
                  \draw[line cap=rect,line width=0.05mm,step=\pal@graphpaperconfigitem,\pal@graphpapercolor,opacity=\pal@graphpaperopacity] (0pt,0pt) grid ++(\pal@pagewidth-\pal@graphpaperx+\pal@outerbleed,\paperheight-\pal@graphpapery);%
                }
              \end{tikzpicture}%
            }
          \else
            \pal@graphpaperx=\dimexpr\pal@pagewidth+\pal@outerbleed\relax
            \put(\pal@dimentonumber{\pal@graphpaperx},\pal@dimentonumber{\pal@graphpapery}){%
              \begin{tikzpicture}%
                \pgflowlevelsynccm%

                \foreach \pal@graphpaperconfigitem in \pal@graphpaperconfig {
                  \draw[line cap=rect,line width=0.05mm,step=\pal@graphpaperconfigitem,\pal@graphpapercolor,opacity=\pal@graphpaperopacity] (0pt,0pt) grid ++(\pal@pagewidth+\pal@outerbleed,\paperheight-\pal@graphpapery);%
                }
              \end{tikzpicture}%
            }
          \fi
        \fi
      \else
        \ifpal@isdoublepage
          \ifpal@rightpage
            \pal@calcgraphpaperoffset
          \fi
        \fi

        \put(\pal@dimentonumber{\pal@graphpaperx},\pal@dimentonumber{\pal@graphpapery}){%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%

            \foreach \pal@graphpaperconfigitem in \pal@graphpaperconfig {
              \draw[line cap=rect,line width=0.05mm,step=\pal@graphpaperconfigitem,\pal@graphpapercolor,opacity=\pal@graphpaperopacity] (0pt,0pt) grid ++(\paperwidth-\pal@graphpaperx,\paperheight-\pal@graphpapery);%
            }
          \end{tikzpicture}%
        }
      \fi
    \fi
  \fi
}

% pages
\newif\ifpal@isbeforepage
\def\pal@currentbeforepage{}
\newcommand\setbeforepage[1]{
  \ifpal@ispage
    \def\pal@currentbeforepage{#1}
  \else
    \global\def\pal@currentbeforepage{#1}
  \fi
}
\def\nobeforepage{\setbeforepage{}}
\newcommand\newbeforepage[2]{
  \expandafter\newcommand\csname pal@before@#1\endcsname{%
    \begingroup%
      #2
    \endgroup%
  }%
}
\newcommand\pal@putbeforepage{
  \ifx\pal@pagegraphic\pal@emptystring
  \else
    \pal@putpagegraphic
  \fi
  \ifx\pal@currentbeforepage\pal@emptystring
  \else
    \ifcsname pal@before@\pal@currentbeforepage\endcsname%
      \pal@isbeforepagetrue
      \csname pal@before@\pal@currentbeforepage\endcsname
      \pal@isbeforepagefalse
    \else
      \pal@errmsg@undefined{before page}{\pal@currentbeforepage}
    \fi
  \fi
  \pal@resetautogrid
}
\newcommand\pal@beforepage{
  \pal@closerows
  \ifx\pal@pagecolor\pal@emptystring
  \else
    \begingroup
      \margin=-1pt
      \topmargin=-1pt
      \bottommargin=-1pt
      \innermargin=\ifpal@fanfold\pal@null\else-1pt\fi
      \outermargin=-1pt
      \setgrid{{{1}}}
      \ifx\pal@pagecolormodel\pal@emptystring
      \else
        \definecolor{tmpcolor}{\pal@pagecolormodel}{\pal@pagecolor}
        \setpagecolor{tmpcolor}
      \fi
      \pal@putxput[1]{0}{0}{1}{1}{%
        \begin{tikzpicture}%
          \pgflowlevelsynccm%
          \fill[\pal@pagecolor] (0,0) rectangle ++(\width,\height);
        \end{tikzpicture}%
      }
    \endgroup
  \fi

  \ifpal@isemptypage
  \else
    \pal@putgraphpaper
  \fi
}
\newcommand\pal@setuppage{
  \global\gutter=\gutter
  \global\margin=\margin
  \global\innermargin=\innermargin
  \global\outermargin=\outermargin
  \global\bottommargin=\bottommargin
  \global\topmargin=\topmargin
  \ifpal@grid\global\pal@gridtrue\else\global\pal@gridfalse\fi
  \ifpal@graphpaper\global\pal@graphpapertrue\else\global\pal@graphpaperfalse\fi
  \ifpal@safezone\global\pal@safezonetrue\else\global\pal@safezonefalse\fi
  \ifpal@placeholder\global\pal@placeholdertrue\else\global\pal@placeholderfalse\fi
  \global\let\pal@defaultborderwidth\pal@defaultborderwidth
  \global\let\pal@defaultborderradius\pal@defaultborderradius
  \global\let\pal@defaultborderopacity\pal@defaultborderopacity
  \global\let\pal@defaultbordercolor\pal@defaultbordercolor
  \global\let\pal@defaultshadowsize\pal@defaultshadowsize
  \global\let\pal@defaultshadowopacity\pal@defaultshadowopacity
  \global\let\pal@defaultshadowcolor\pal@defaultshadowcolor
  \global\let\pal@defaultshadowxshift\pal@defaultshadowxshift
  \global\let\pal@defaultshadowyshift\pal@defaultshadowyshift
  \global\let\pal@pagegraphicoptionscale\pal@pagegraphicoptionscale
  \global\let\pal@pagegraphicoptionvpos\pal@pagegraphicoptionvpos
  \global\let\pal@pagegraphicoptionhpos\pal@pagegraphicoptionhpos
  \global\let\pal@pagegraphicoptionunsharp\pal@pagegraphicoptionunsharp

  \pal@pagewidth=\pagewidth
  \pal@pageheight=\pageheight
  \pal@outerbleed=\ifdim\outerbleed=\pal@undefdim\bleed\else\outerbleed\fi
  \pal@innerbleed=\ifdim\innerbleed=\pal@undefdim\bleed\else\innerbleed\fi
  \pal@topbleed=\ifdim\topbleed=\pal@undefdim\bleed\else\topbleed\fi
  \pal@bottombleed=\ifdim\bottombleed=\pal@undefdim\bleed\else\bottombleed\fi
  \pal@outersafetymargin=\ifdim\outersafetymargin=\pal@undefdim\safetymargin\else\outersafetymargin\fi
  \pal@innersafetymargin=\ifdim\innersafetymargin=\pal@undefdim\safetymargin\else\innersafetymargin\fi
  \pal@topsafetymargin=\ifdim\topsafetymargin=\pal@undefdim\safetymargin\else\topsafetymargin\fi
  \pal@bottomsafetymargin=\ifdim\bottomsafetymargin=\pal@undefdim\safetymargin\else\bottomsafetymargin\fi

  \ifpal@haspages
    \ifpal@twoside
      \ifpal@leftpage
        \global\pal@rightpagetrue
        \global\pal@leftpagefalse
      \else
        \global\pal@rightpagefalse
        \global\pal@leftpagetrue
      \fi
    \fi
  \else
    \pal@isinitgridfalse
    \ifpal@beginleft
      \global\pal@leftpagetrue
    \fi
    \ifpal@beginright
      \global\pal@beginleftfalse
      \global\pal@beginrightfalse
      \global\pal@leftpagefalse
    \fi
    \ifpal@leftpage
      \pal@haspagestrue
      \global\pal@leftpagetrue
      \global\pal@rightpagefalse
    \else
      \ifpal@fanfold
        \global\pal@rightpagefalse
        \global\pal@leftpagetrue
        \setcounter{page}{0}
        \pal@emptypage
        \global\pal@rightpagetrue
        \global\pal@leftpagefalse
        \global\pal@haslastemptypagetrue
      \else
        \ifpal@hascover
          \ifpal@fillpages
            \ifpal@twoside
              \global\pal@rightpagefalse
              \global\pal@leftpagetrue
              \setcounter{page}{0}
              \pal@emptypage
              \global\pal@rightpagetrue
              \global\pal@leftpagefalse
              \global\pal@haslastemptypagetrue
            \else
              \pal@haspagestrue
              \global\pal@rightpagetrue
            \fi
          \else
            \pal@haspagestrue
            \global\pal@rightpagetrue
          \fi
        \else
          \pal@haspagestrue
          \global\pal@rightpagetrue
        \fi
      \fi
    \fi
  \fi
}
\newcommand\pal@setupcover{
  \pal@isinitgridfalse
  \pal@pagewidth=\ifdim\coverwidth=\pal@undefdim\pagewidth\else\coverwidth\fi
  \pal@pageheight=\ifdim\coverheight=\pal@undefdim\pageheight\else\coverheight\fi
  \pal@outerbleed=\ifdim\coverouterbleed=\pal@undefdim\ifdim\coverbleed=\pal@undefdim\ifdim\outerbleed=\pal@undefdim\bleed\else\outerbleed\fi\else\coverbleed\fi\else\coverouterbleed\fi
  \pal@innerbleed=\ifdim\coverinnerbleed=\pal@undefdim\ifdim\coverbleed=\pal@undefdim\ifdim\innerbleed=\pal@undefdim\bleed\else\innerbleed\fi\else\coverbleed\fi\else\coverinnerbleed\fi
  \pal@topbleed=\ifdim\covertopbleed=\pal@undefdim\ifdim\coverbleed=\pal@undefdim\ifdim\topbleed=\pal@undefdim\bleed\else\topbleed\fi\else\coverbleed\fi\else\covertopbleed\fi
  \pal@bottombleed=\ifdim\coverbottombleed=\pal@undefdim\ifdim\coverbleed=\pal@undefdim\ifdim\bottombleed=\pal@undefdim\bleed\else\bottombleed\fi\else\coverbleed\fi\else\coverbottombleed\fi
  \pal@outersafetymargin=\ifdim\coveroutersafetymargin=\pal@undefdim\ifdim\coversafetymargin=\pal@undefdim\ifdim\outersafetymargin=\pal@undefdim\safetymargin\else\outersafetymargin\fi\else\coversafetymargin\fi\else\coveroutersafetymargin\fi
  \pal@innersafetymargin=\ifdim\coverinnersafetymargin=\pal@undefdim\ifdim\coversafetymargin=\pal@undefdim\ifdim\innersafetymargin=\pal@undefdim\safetymargin\else\innersafetymargin\fi\else\coversafetymargin\fi\else\coverinnersafetymargin\fi
  \pal@topsafetymargin=\ifdim\covertopsafetymargin=\pal@undefdim\ifdim\coversafetymargin=\pal@undefdim\ifdim\topsafetymargin=\pal@undefdim\safetymargin\else\topsafetymargin\fi\else\coversafetymargin\fi\else\covertopsafetymargin\fi
  \pal@bottomsafetymargin=\ifdim\coverbottomsafetymargin=\pal@undefdim\ifdim\coversafetymargin=\pal@undefdim\ifdim\bottomsafetymargin=\pal@undefdim\safetymargin\else\bottomsafetymargin\fi\else\coversafetymargin\fi\else\coverbottomsafetymargin\fi
}
\newif\ifpal@pageoptiondouble
\newif\ifpal@pageoptionfrontcover
\newif\ifpal@pageoptionbackcover
\newdimen\pal@backcovergutter
\newdimen\pal@backcovermargin
\newdimen\pal@backcovertopmargin
\newdimen\pal@backcoverbottommargin
\newdimen\pal@backcoverinnermargin
\newdimen\pal@backcoveroutermargin
\pgfkeys{
  /pagetype/.is family,
  /pagetype,
  double/.is if=pal@pageoptiondouble,
  front cover/.is if=pal@pageoptionfrontcover,
  back cover/.is if=pal@pageoptionbackcover,
  .unknown/.code=
}
\pgfkeys{
  /page/.is family,
  /page,
  gutter/.store in=\pal@pageoptiongutter,
  gutter=\gutter,
  margin/.store in=\pal@pageoptionmargin,
  margin=\margin,
  top margin/.store in=\pal@pageoptiontopmargin,
  top margin=\topmargin,
  bottom margin/.store in=\pal@pageoptionbottommargin,
  bottom margin=\bottommargin,
  inner margin/.store in=\pal@pageoptioninnermargin,
  inner margin=\innermargin,
  outer margin/.store in=\pal@pageoptionoutermargin,
  outer margin=\outermargin,
  vpos/.code={\pal@gridvalign{#1}},
  hpos/.code={\pal@gridhalign{#1}},
  color/.store in=\pal@pageoptioncolor,
  color=,
  page color/.code={\setpagecolor{#1}},
  page graphic/.code={\setpagegraphic{#1}},
  before page/.code={\setbeforepage{#1}},
  double/.code={},
  front cover/.code={},
  back cover/.code={},
}
\pgfkeys{
  /backcover/.is family,
  /backcover,
  gutter/.store in=\pal@backcoveroptiongutter,
  gutter=\gutter,
  margin/.store in=\pal@backcoveroptionmargin,
  margin=\margin,
  top margin/.store in=\pal@backcoveroptiontopmargin,
  top margin=\topmargin,
  bottom margin/.store in=\pal@backcoveroptionbottommargin,
  bottom margin=\bottommargin,
  inner margin/.store in=\pal@backcoveroptioninnermargin,
  inner margin=\innermargin,
  outer margin/.store in=\pal@backcoveroptionoutermargin,
  outer margin=\outermargin,
  vpos/.store in=\pal@backcoveroptionvpos,
  vpos=0.5,
  hpos/.store in=\pal@backcoveroptionhpos,
  hpos=0.5,
  color/.store in=\pal@backcoveroptioncolor,
  color=,
  page color/.store in=\pal@backcoveroptionpagecolor,
  page color=,
  page graphic/.store in=\pal@backcoveroptionpagegraphic,
  page graphic=,
  before page/.code={},
  double/.code={},
  front cover/.code={},
  back cover/.code={},
}
\newcommand\pal@applypageoptions[1]{
  \pgfkeys{/page,#1}
  \gutter=\pal@pageoptiongutter
  \margin=\pal@pageoptionmargin
  \topmargin=\pal@pageoptiontopmargin
  \bottommargin=\pal@pageoptionbottommargin
  \innermargin=\pal@pageoptioninnermargin
  \outermargin=\pal@pageoptionoutermargin

  \pal@beforepage
}
\newcommand\pal@applybackcoveroptions{
  \pal@gridvalign{\pal@backcoveroptionvpos}
  \pal@gridhalign{\pal@backcoveroptionhpos}

  \ifx\pal@backcoveroptionpagecolor\pal@emptystring
    \def\pal@pagecolor{}
  \else
    \setpagecolor{\pal@backcoveroptionpagecolor}
  \fi
  \ifx\pal@backcoveroptionpagegraphic\pal@emptystring
    \def\pal@pagegraphic{}
  \else
    \def\pal@pagegraphic{\pal@backcoveroptionpagegraphicfile}
    \def\pal@pagegraphicoptionscale{\pal@backcoveroptionpagegraphicscale}
    \def\pal@pagegraphicoptionvpos{\pal@backcoveroptionpagegraphicvpos}
    \def\pal@pagegraphicoptionhpos{\pal@backcoveroptionpagegraphichpos}
    \def\pal@pagegraphicoptionunsharp{\pal@backcoveroptionpagegraphicunsharp}
  \fi
  \ifx\pal@backcoveroptioncolor\pal@emptystring
    \def\pal@pageoptioncolor{\pal@backcovercolor}
  \else
    \def\pal@pageoptioncolor{\pal@backcoveroptioncolor}
  \fi
  \setborder[radius=\pal@backcoveroptionborderradius,width=\pal@backcoveroptionborderwidth,opacity=\pal@backcoveroptionborderopacity,color=\pal@backcoveroptionbordercolor]{}
  \setshadow[size=\pal@backcoveroptionshadowsize,opacity=\pal@backcoveroptionshadowopacity,color=\pal@backcoveroptionshadowcolor,xshift=\pal@backcoveroptionshadowxshift,yshift=\pal@backcoveroptionshadowyshift]{}
  \gutter=\pal@backcovergutter
  \margin=\pal@backcovermargin
  \topmargin=\pal@backcovertopmargin
  \bottommargin=\pal@backcoverbottommargin
  \innermargin=\pal@backcoverinnermargin
  \outermargin=\pal@backcoveroutermargin

  \ifdefined\pal@backcovergrid
    \pal@backcovergrid
  \fi

  \pal@beforepage
}
\newcommand\page[2][]{
  \pal@pageoptiondoublefalse
  \pal@pageoptionfrontcoverfalse
  \pal@pageoptionbackcoverfalse
  \pgfkeys{/pagetype,#1}
  \ifpal@pageoptiondouble
    \pal@doublepage[#1]{#2}
  \else
    \ifpal@pageoptionfrontcover
      \pal@frontcover[#1]{#2}
    \else
      \ifpal@pageoptionbackcover
        \pal@backcover[#1]{#2}
      \else
        \pal@standardpage[#1]{#2}
      \fi
    \fi
  \fi
}
\newcommand\xpage[2][]{}
\newcommand\pal@standardpage[2][]{
  \global\pal@placeholdercounter=0\relax
  \ifpal@backcover
    \pal@setupcover
  \else
    \pal@setuppage
  \fi
  \pal@ispagetrue
  \global\pal@topmargintmp=\topmargin\global\topmargin=\pal@undefdim
  \pal@setdimensions
  \ifpal@fanfold
    \ifpal@leftpage
      \global\pal@isfanfoldopentrue
      \begin{picture}(\pal@dimentonumber\paperwidth,\pal@dimentonumber\paperheight)
    \fi
  \else
    \begin{picture}(\pal@dimentonumber\paperwidth,\pal@dimentonumber\paperheight)
  \fi
  \topmargin=\pal@topmargintmp
  \begingroup
    \ifpal@fanfold
      \ifpal@pagenumberinghaschanged
        \global\pal@pagenumberinghaschangedfalse
      \else
        \ifpal@rightpage
          \global\addtocounter{page}{1}
        \fi
      \fi
    \fi
    \ifpal@backcover
      \pal@applybackcoveroptions
    \else
      \pal@applypageoptions{#1}
    \fi
    \pal@putbeforepage
    #2
    \pal@putbleed
    \pal@putgrid
    \pal@putcuttingmarks
    \pal@putsafezone
  \endgroup
  \ifpal@fanfold
    \ifpal@rightpage
      \ifnum\pal@tocfixpageoffset=-1
        \addtocounter{page}{-1}
      \fi
      \global\pal@isfanfoldopenfalse
      \end{picture}
      \ifnum\pal@tocfixpageoffset=-1
        \addtocounter{page}{1}
        \global\def\pal@tocfixpageoffset{0}
      \fi
    \fi
  \else
    \end{picture}
  \fi
  \global\topmargin=\pal@topmargintmp
  \pal@ispagefalse
}
\newcommand\pal@doublepage[2][]{
  \global\pal@placeholdercounter=0\relax
  \ifpal@twoside
    \ifpal@haspages
      \ifpal@leftpage\page{}\fi
    \else
      \ifpal@beginleft
        \ifpal@beginright
          \page{}
        \fi
      \else
        \page{}
      \fi
    \fi
    \pal@ispagetrue
    \global\pal@isdoublepagetrue
    \pal@setuppage
    \global\pal@topmargintmp=\topmargin\global\topmargin=\pal@undefdim
    \pal@setdimensions
    \begin{picture}(\pal@dimentonumber\paperwidth,\pal@dimentonumber\paperheight)
      \topmargin=\pal@topmargintmp
      \pal@applypageoptions{#1}
      \pal@putbeforepage
      #2
      \pal@putbleed
      \pal@putgrid
      \pal@putcuttingmarks
      \pal@putsafezone
      \ifnum\pal@tocfixpageoffset=1
        \addtocounter{page}{1}
      \fi
    \end{picture}

    \pal@setuppage
    \ifpal@fanfold
      \ifnum\pal@tocfixpageoffset=1
        \global\def\pal@tocfixpageoffset{0}
      \else
        \addtocounter{page}{1}
      \fi
    \else
      \pal@setdimensions
      \begin{picture}(\pal@dimentonumber\paperwidth,\pal@dimentonumber\paperheight)
        \topmargin=\pal@topmargintmp
        \pal@applypageoptions{#1}
        \global\pal@placeholdercounter=0\relax
        \pal@putbeforepage
        #2
        \pal@putbleed
        \pal@putgrid
        \pal@putcuttingmarks
        \pal@putsafezone
      \end{picture}
    \fi
    \global\pal@isdoublepagefalse
    \global\topmargin=\pal@topmargintmp
    \pal@ispagefalse
  \else
    \pal@standardpage[#1]{#2}
  \fi
}
\newcommand\pal@backcover[2][]{
  \ifpal@hascover
    \pal@errmsg@backcoverdefinedafterfrontcover
  \else
    \ifdefined\pal@tmpgrid
      \let\pal@backcovergrid\pal@tmpgrid
    \fi
    \edef\pal@backcovercolor{\paloptions@color}
    \pgfkeys{/backcover,#1}
    \pal@backcovergutter=\pal@backcoveroptiongutter
    \pal@backcovermargin=\pal@backcoveroptionmargin
    \pal@backcovertopmargin=\pal@backcoveroptiontopmargin
    \pal@backcoverbottommargin=\pal@backcoveroptionbottommargin
    \pal@backcoverinnermargin=\pal@backcoveroptioninnermargin
    \pal@backcoveroutermargin=\pal@backcoveroptionoutermargin
    \ifx\pal@backcoveroptionpagecolor\pal@emptystring
      \let\pal@backcoveroptionpagecolor\pal@pagecolor
    \fi
    \ifx\pal@backcoveroptionpagegraphic\pal@emptystring
      \let\pal@backcoveroptionpagegraphic\pal@pagegraphic
      \let\pal@backcoveroptionpagegraphicfile\pal@pagegraphic
      \ifdefined\pal@pagegraphicoptionscale
        \let\pal@backcoveroptionpagegraphicscale\pal@pagegraphicoptionscale
      \fi
      \ifdefined\pal@pagegraphicoptionhpos
        \let\pal@backcoveroptionpagegraphichpos\pal@pagegraphicoptionhpos
      \fi
      \ifdefined\pal@pagegraphicoptionvpos
        \let\pal@backcoveroptionpagegraphicvpos\pal@pagegraphicoptionvpos
      \fi
      \ifdefined\pal@pagegraphicoptionunsharp
        \let\pal@backcoveroptionpagegraphicunsharp\pal@pagegraphicoptionunsharp
      \fi
    \else
      \ifcsname pal@graphic@\pal@backcoveroptionpagegraphic\endcsname
        \csname pal@graphic@\pal@backcoveroptionpagegraphic\endcsname[1]{}
      \else
        \def\pal@backcoveroptionpagegraphicfile{\pal@backcoveroptionpagegraphic}
        \def\pal@backcoveroptionpagegraphicscale{1}
        \def\pal@backcoveroptionpagegraphichpos{0.5}
        \def\pal@backcoveroptionpagegraphicvpos{0.5}
        \def\pal@backcoveroptionpagegraphicunsharp{\pal@unsharp}
      \fi
    \fi
    \let\pal@backcoveroptionborderradius\pal@defaultborderradius
    \let\pal@backcoveroptionborderopacity\pal@defaultborderopacity
    \let\pal@backcoveroptionborderwidth\pal@defaultborderwidth
    \let\pal@backcoveroptionbordercolor\pal@defaultbordercolor
    \let\pal@backcoveroptionshadowopacity\pal@defaultshadowopacity
    \let\pal@backcoveroptionshadowsize\pal@defaultshadowsize
    \let\pal@backcoveroptionshadowcolor\pal@defaultshadowcolor
    \let\pal@backcoveroptionshadowxshift\pal@defaultshadowxshift
    \let\pal@backcoveroptionshadowyshift\pal@defaultshadowyshift

    \ifdefined\pal@currentcontents
      \let\pal@backcovercontent\pal@currentcontents
      \def\pal@backcovertemplate{#2}
    \else
      \def\pal@backcovercontent{#2}
    \fi
  \fi
}
\newcommand\pal@frontcover[2][]{
  \pal@ispagetrue
  \pal@hascovertrue
  \pal@setupcover
  \setcounter{page}{0}
  \global\pal@topmargintmp=\topmargin\global\topmargin=\pal@undefdim
  \ifpal@cover
    \global\pal@frontcovertrue
    \pal@setdimensions
    \begin{picture}(\pal@dimentonumber\paperwidth,\pal@dimentonumber\paperheight)
      \topmargin=\pal@topmargintmp
      \global\pal@backcovertrue
      \def\pal@currentbeforepage{}
      \begingroup
        \ifdefined\pal@backcovercontent
          \pal@applybackcoveroptions
          \pal@putbeforepage
          \ifdefined\pal@backcovertemplate
            \pal@placeholdercounter 0\relax%
            \let\pal@currentcontents\pal@backcovercontent%
            \pal@backcovertemplate%
          \else
            \pal@backcovercontent
          \fi
        \fi
        \pal@putbleed
        \pal@putgrid
        \pal@putcuttingmarks
        \pal@putsafezone
      \endgroup
      \global\pal@backcoverfalse
      \pal@resetautogrid
      \pal@gridoffsetx=\dimexpr(\pal@pagewidth + \pal@outerbleed - \pal@innerbleed + \spinewidth)\relax
      \pal@applypageoptions{#1}
      \global\pal@placeholdercounter=0\relax
      \pal@putbeforepage
      #2
      \pal@putbleed
      \pal@putgrid
      \pal@putcuttingmarks
      \pal@putsafezone
    \end{picture}
    \global\pal@frontcoverfalse
    \let\pal@backcovercontent\undefined
  \else
    \pal@setdimensions
    \begin{picture}(\pal@dimentonumber\paperwidth,\pal@dimentonumber\paperheight)
      \topmargin=\pal@topmargintmp
      \pal@applypageoptions{#1}
      \def\pal@currentbeforepage{}
      \pal@putbeforepage
      #2
      \pal@putbleed
      \pal@putgrid
      \pal@putcuttingmarks
      \pal@putsafezone
    \end{picture}
  \fi
  \global\topmargin=\pal@topmargintmp
  \pal@ispagefalse
}
\newcommand\leftpage[1]{
  \ifpal@leftpage
    \pal@renderleftpage{#1}
  \else
    \ifpal@fanfold
      \ifpal@isdoublepage
        \pal@renderleftpage{#1}
      \fi
    \else
      \ifpal@isdoublepage
        \pal@renderleftpage[1]{#1}
      \fi
    \fi
  \fi
}
\newcommand\rightpage[1]{
  \ifpal@rightpage
    \pal@renderrightpage{#1}
  \else
    \ifpal@fanfold
      \ifpal@isdoublepage
        \pal@renderrightpage{#1}
      \fi
    \else
      \ifpal@isdoublepage
        \pal@renderrightpage[1]{#1}
      \fi
    \fi
  \fi
}
\newcommand\pal@renderleftpage[2][0]{
  \begingroup
    \pal@isdoublepagefalse
    \pal@setdimensions
    \pal@closerows
    \ifnum#1=1
      \pal@drymodetrue
    \fi
      #2
    \ifnum#1=1
      \pal@drymodefalse
    \else
      \ifpal@isbeforepage
      \else
        \pal@putgrid
      \fi
    \fi
  \endgroup
}
\newif\ifpal@wasdoublepage
\newif\ifpal@renderrightpage
\newcommand\pal@renderrightpage[2][0]{
  \pal@renderrightpagetrue
  \begingroup
    \ifpal@fanfold
      \ifpal@isdoublepage
        \pal@wasdoublepagetrue
        \addtocounter{page}{1}
      \fi
    \fi
    \pal@isdoublepagefalse
    \pal@rightpagetrue
    \pal@leftpagefalse
    \pal@setdimensions
    \pal@closerows
    \ifnum#1=1
      \pal@drymodetrue
    \fi
      #2
    \ifnum#1=1
      \pal@drymodefalse
    \else
      \ifpal@isbeforepage
      \else
        \pal@putgrid
      \fi
    \fi
    \ifpal@fanfold
      \ifpal@wasdoublepage
        \pal@wasdoublepagefalse
        \addtocounter{page}{-1}
      \fi
    \fi
  \endgroup
  \pal@renderrightpagefalse
}

% templates
\newif\ifpal@drymode
\newif\ifpal@placeholderoptions
\newif\ifpal@placeholdermode
\newif\ifpal@isplace
\newif\ifpal@template
\newif\ifpal@currentplaceholder
\pal@placeholderoptionstrue
\newcount\pal@placeholdercounter
\newcount\pal@contentcounter
\newdimen\pal@placeholderfontsize
\def\pal@frameyymax{0}
\def\pal@framexxmax{0}
\def\pal@setgridframe#1 #2 #3 #4 \\{
  \def\pal@framey{#1}
  \def\pal@framex{#2}
  \def\pal@frameyy{#3}
  \def\pal@framexx{#4}
}
\def\pal@setdefaultgridframe#1 #2 #3 #4 \\{
  \def\pal@defaultframey{#1}
  \def\pal@defaultframex{#2}
  \def\pal@defaultframeyy{#3}
  \def\pal@defaultframexx{#4}
  \pal@setgridframe #1 #2 #3 #4 \\
}
\def\pal@resetgridframe{
  \global\pal@isplacefalse
  \pgfmathceil{\pal@frameyy}
  \pgfmathint{\pgfmathresult}
  \global\edef\pal@currentrow{\pgfmathresult}
  \ifnum\pal@currentrow>\pal@frameyymax
    \global\edef\pal@frameyymax{\pal@currentrow}
    \global\def\pal@framexxmax{0}
  \fi
  \pgfmathceil{\pal@framexx}
  \pgfmathint{\pgfmathresult}
  \global\edef\pal@currentcell{\pgfmathresult}
  \ifnum\pal@currentcell>\pal@framexxmax
    \global\edef\pal@framexxmax{\pal@currentcell}
  \fi

  \pgfmathqparse{\pal@get{\pal@frameyymax C}pt>\pal@framexxmax pt}
  \ifnum\pgfmathresult=1
    \global\edef\pal@framey{\the\numexpr\pal@frameyymax-1\relax}
    \global\edef\pal@framex{\pal@framexxmax}
    \global\edef\pal@frameyy{\pal@frameyymax}
    \global\edef\pal@framexx{\the\numexpr\pal@framexxmax+1\relax}
  \else
    \ifnum\pal@frameyymax=\pal@rowscount
      \global\pal@gridfulltrue
    \else
      \global\edef\pal@framey{\pal@frameyymax}
      \global\edef\pal@framex{0}
      \global\edef\pal@frameyy{\the\numexpr\pal@frameyymax+1\relax}
      \global\edef\pal@framexx{1}
    \fi
  \fi
}
\newcommand\placeholder[2][0]{
  \begingroup
  \ifx#2\pal@emptystring
  \else
    \global\pal@isplacetrue
  \fi
  \def\pal@currentplaceholdercontent{}
  \ifnum#1=0
    \global\advance \pal@placeholdercounter by 1
  \else
    \global\pal@placeholdercounter=#1
  \fi
  \pal@contentcounter 0\relax
  \def\pal@tmp{\pal@currentcontents}
  \pal@placeholdermode{1}
  \pal@tmp
  \pal@templatetrue
  \pal@placeholdermode{0}
  \pal@putcontent{
    \ifpal@currentplaceholder
      \ifx#2\pal@emptystring
      \else
        \pal@setgridframe #2 \\
      \fi
      \ifx\pal@currentplaceholderoptions\pal@emptystring
        \pal@placeholderoptionsfalse
        \csname \pal@currentplaceholdertype\endcsname{\pal@currentplaceholdercontent}
        \pal@placeholderoptionstrue
      \else
        \csname \pal@currentplaceholdertype\endcsname[\pal@currentplaceholderoptions]{\pal@currentplaceholdercontent}
      \fi
    \else
      \ifpal@placeholder
        \ifx#2\pal@emptystring
        \else
          \pal@setgridframe #2 \\
        \fi
        \pal@textboxheight=\dimexpr(\posy{1}{\pal@framey} - \posy{-1}{\pal@frameyy})\relax
        \pal@textboxwidth=\dimexpr(\posx{-1}{\pal@frameyy}{-1}{\pal@framexx} - \posx{1}{\pal@framey}{1}{\pal@framex})\relax
        \ifdim\pal@textboxwidth>\pal@textboxheight
          \pal@placeholderfontsize=0.5\pal@textboxheight
        \else
          \pal@placeholderfontsize=0.5\pal@textboxwidth
        \fi
        \ifdim\pal@placeholderfontsize>1000pt
          \pal@placeholderfontsize=1000pt
        \fi
        \pal@putxput{\pal@framey}{\pal@framex}{\pal@frameyy}{\pal@framexx}{%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%
            \filldraw[line width=0.1mm,draw=cyan!60,fill=cyan!30,opacity=0.3] (0,0) rectangle ++(\width,\height);
            \ifdim\pal@placeholderfontsize>5mm
              \node[opacity=0.3] at (0.5\width,0.5\height){
                \fontsize{\pal@placeholderfontsize}{0pt}\selectfont\textcolor{cyan!60}{\textbf{\the\pal@placeholdercounter}}
              };
            \fi
          \end{tikzpicture}%
        }
        \pal@resetgridframe
      \else
        \ifx\pal@currentplaceholdertype\pal@placeholdertypeusetext
          \ifx#2\pal@emptystring
          \else
            \pal@setgridframe #2 \\
          \fi
          \ifx\pal@currentplaceholderoptions\pal@emptystring
            \pal@placeholderoptionsfalse
            \csname \pal@currentplaceholdertype\endcsname
            \pal@placeholderoptionstrue
          \else
            \csname \pal@currentplaceholdertype\endcsname[\pal@currentplaceholderoptions]
          \fi
        \fi
      \fi
    \fi
  }
  \pal@templatefalse
  \endgroup
}
\newcommand\pal@graphic[2][]{
  \advance \pal@contentcounter by 1
  \ifnum\pal@contentcounter=\pal@placeholdercounter
    \def\pal@currentplaceholdertype{graphic}
    \def\pal@currentplaceholderoptions{}
    \pgfkeys{graphic,file={#2},scale=1,vpos=0.5,hpos=0.5,unsharp=\pal@unsharp,#1}
    \ifcsname pal@graphic@#2\endcsname%
      \csname pal@graphic@#2\endcsname[2]{#1}%
    \fi

    \edef\pal@currentplaceholdercontent{\pal@graphicoptionfile}
    \pal@currentplaceholdertrue
  \fi
}
\newcommand\pal@xput[1]{
  \advance \pal@contentcounter by 1
  \ifnum\pal@contentcounter=\pal@placeholdercounter
    \def\pal@currentplaceholdertype{xput}
    \def\pal@currentplaceholderoptions{}
    \def\pal@currentplaceholdercontent{#1}
    \pal@currentplaceholdertrue
  \fi
}
\newcommand\pal@tikz[1]{
  \advance \pal@contentcounter by 1
  \ifnum\pal@contentcounter=\pal@placeholdercounter
    \def\pal@currentplaceholdertype{tikzgraphic}
    \def\pal@currentplaceholderoptions{}
    \def\pal@currentplaceholdercontent{#1}
    \pal@currentplaceholdertrue
  \fi
}
\newcommand\pal@text[2][]{
  \advance \pal@contentcounter by 1
  \ifnum\pal@contentcounter=\pal@placeholdercounter
    \def\pal@currentplaceholdertype{text}
    \def\pal@currentplaceholderoptions{}
    \edef\pal@currentborderradius{\pal@defaultborderradius}
    \edef\pal@currentborderwidth{\pal@defaultborderwidth}
    \edef\pal@currentbordercolor{\pal@defaultbordercolor}
    \edef\pal@currentborderopacity{\pal@defaultborderopacity}
    \pgfkeys{text,name=default,color=\ifx\pal@pageoptioncolor\pal@emptystring\paloptions@color\else\pal@pageoptioncolor\fi,border radius=\pal@currentborderradius,border width=\pal@currentborderwidth,border color=\pal@currentbordercolor,border opacity=\pal@currentborderopacity,#1}
    \def\pal@currentplaceholdercontent{#2}
    \pal@currentplaceholdertrue
  \fi
}
\def\pal@placeholdertypeusetext{usetext}
\newcommand\pal@usetext[1][default]{
  \advance \pal@contentcounter by 1
  \ifnum\pal@contentcounter=\pal@placeholdercounter
    \edef\pal@currentplaceholdertype{\pal@placeholdertypeusetext}
    \def\pal@currentplaceholderoptions{#1}
    \def\pal@currentplaceholdercontent{}
    \pal@currentplaceholdertrue
  \fi
}
\newcommand\pal@rendertemplate[3]{
  \pal@placeholdercounter 0\relax%
  \global\def\pal@currentcontents{#2}%
  \page[#1]{%
    #3
  }%
}
\newcommand{\newtemplate}[3][]{
  \expandafter\newcommand\csname pal@template@#2\endcsname[2][]{%
    \pal@rendertemplate{#1,##1}{##2}{#3}
  }%
}
\newcommand\template[3][]{
  \ifcsname pal@template@#2\endcsname%
  \else%
    \newtemplate[]{#2}{
      \pal@gridsc{#2}
    }
  \fi
  \csname pal@template@#2\endcsname[#1]{
    #3
  }
}
\newcommand\xtemplate[3][]{}
\newcommand\graphic{}
\newcommand\xput{}
\newcommand\tikzgraphic{}
\newcommand\usetext{}
\newcommand\text{}
\newcommand\pal@putcontent[1]{
  \ifpal@drymode
  \else
    \begingroup
    \ifpal@gridfull
      \ifpal@isplace#1\fi
    \else
      #1
    \fi
    \endgroup
  \fi
}
\newcommand\pal@placeholdermode[1]{
  \pal@placeholdermodefalse
  \ifnum#1=0%
    \renewcommand\graphic[2][]{%
      \pal@putcontent{%
        \def\pal@graphicoptionfile{##2}
        \ifpal@placeholderoptions
          \ifcsname pal@graphic@##2\endcsname%
            \csname pal@graphic@##2\endcsname[2]{##1}
          \else
            \ifpal@template\else
              \pgfkeys{graphic,file={##2},scale=1,vpos=0.5,hpos=0.5,unsharp=\pal@unsharp,##1}
            \fi
          \fi
        \fi
        \pal@putgraphic{\pal@framey}{\pal@framex}{\pal@frameyy}{\pal@framexx}{\pal@graphicoptionfile}%
        \pal@resetgridframe
      }
    }%
    \renewcommand\xput[1]{%
      \pal@putcontent{%
        \pal@putxput{\pal@framey}{\pal@framex}{\pal@frameyy}{\pal@framexx}{##1}%
        \pal@resetgridframe
      }
    }%
    \renewcommand\tikzgraphic[1]{%
      \pal@putcontent{%
        \pal@puttikz{\pal@framey}{\pal@framex}{\pal@frameyy}{\pal@framexx}{##1}%
        \pal@resetgridframe
      }
    }%
    \renewcommand\usetext[1][default]{%
      \pal@putcontent{%
        \pal@putusetext[##1]{\pal@framey}{\pal@framex}{\pal@frameyy}{\pal@framexx}%
        \pal@resetgridframe
      }
    }%
    \renewcommand\text[2][]{%
      \pal@putcontent{%
        \edef\pal@currentborderradius{\pal@defaultborderradius}
        \edef\pal@currentborderwidth{\pal@defaultborderwidth}
        \edef\pal@currentbordercolor{\pal@defaultbordercolor}
        \edef\pal@currentborderopacity{\pal@defaultborderopacity}
        \ifpal@template\else
          \pgfkeys{text,name=default,color=\ifx\pal@pageoptioncolor\pal@emptystring\paloptions@color\else\pal@pageoptioncolor\fi,border radius=\pal@currentborderradius,border width=\pal@currentborderwidth,border color=\pal@currentbordercolor,border opacity=\pal@currentborderopacity,##1}
        \fi
        \pal@puttext{\pal@framey}{\pal@framex}{\pal@frameyy}{\pal@framexx}{##2}%
        \pal@resetgridframe
      }
    }%
  \else%
    \pal@placeholdermodetrue
    \renewcommand\graphic[2][]{%
      \pal@graphic[##1]{##2}%
    }%
    \renewcommand\xput[1]{%
      \pal@xput{##1}%
    }%
    \renewcommand\tikzgraphic[1]{%
      \pal@tikz{##1}%
    }%
    \renewcommand\usetext[1][default]{%
      \pal@usetext[##1]%
    }
    \renewcommand\text[2][]{%
      \pal@text[##1]{##2}%
    }
  \fi%
}
\pal@placeholdermode{0}
\newcommand\place[1]{
  \pal@isplacetrue
  \pal@setgridframe #1 \\
}
\pal@setdefaultgridframe 0 0 1 1 \\

\newcommand\pal@emptypage{
  \global\pal@isemptypagetrue
  \page[before page=,page graphic=,page color=]{}
  \global\pal@isemptypagefalse
}

\def\pal@tocfixpageoffset{0}
\def\sectioncalled{
  \ifpal@fanfold
    \ifpal@isdoublepage
      \ifpal@rightpage
        \global\def\pal@tocfixpageoffset{1}
      \fi
    \else
      \ifpal@renderrightpage
        \global\def\pal@tocfixpageoffset{1}
      \else
        \ifpal@leftpage
          \global\def\pal@tocfixpageoffset{-1}
        \fi
      \fi
    \fi
  \fi
}

\def\pal@turbojobname{pagelayoutturbobatchoptimizexyz}
\edef\pal@turbojobname{\meaning\pal@turbojobname}
\edef\pal@jobname{\jobname}
\edef\pal@jobname{\meaning\pal@jobname}
\AtBeginDocument{
  % fanfold toc partial fix
  \let\pal@originalsection\section
  \def\pal@nextsection#1{
    \sectioncalled
    \@ifnextchar\bgroup{\pal@originalsection*}{\pal@originalsection{#1}}}
  \let\section\pal@nextsection
  \let\pal@originalsubsection\subsection
  \def\pal@nextsubsection#1{
    \sectioncalled
    \@ifnextchar\bgroup{\pal@originalsubsection*}{\pal@originalsubsection{#1}}}
  \let\subsection\pal@nextsubsection

  \ifpal@optimize
  \else
    \pal@isturbomodefalse
  \fi

  \ifpal@isturbomode
    \ifx\pal@jobname\pal@turbojobname
      \pal@placeholderfalse
      \pal@gridfalse
      \pal@safezonefalse
      \pal@cuttingmarksfalse
      \pal@fillpagesfalse
      \pal@graphpaperfalse
      \pal@preflightfalse

      \pal@isbatchmodetrue
    \else
      \pal@start
    \fi
  \else
    \ifpal@import
      \pal@start
    \fi
  \fi

  \ifx\pal@pagegraphic\pal@emptystring
    \ifx\paloptions@pagegraphic\pal@emptystring
    \else
      \setpagegraphic{\paloptions@pagegraphic}
    \fi
  \fi

  \ifpal@fanfold
    \pal@covertrue
  \fi
}
\AtEndDocument{
  \ifpal@beginleft
    \ifpal@leftpage
      \pal@hasoddnumberofpagestrue
    \fi
  \else
    \ifpal@rightpage
      \pal@hasoddnumberofpagestrue
    \fi
  \fi
  \ifdefined\pal@backcovercontent
    \pal@haspagestrue
    \ifpal@haslastemptypage
      \ifpal@hasoddnumberofpages
        \pal@standardpage[before page=]{}
        \pal@emptypage
      \else
        \pal@emptypage
      \fi
    \else
      \ifpal@twoside
        \ifpal@hasoddnumberofpages\page[before page=]{}\fi
      \fi
    \fi
    \pal@leftpagetrue
    \pal@rightpagefalse
    \pal@backcovertrue
    \ifdefined\pal@backcovertemplate
      \pal@placeholdercounter 0\relax%
      \let\pal@currentcontents\pal@backcovercontent%
      \def\pal@currentbeforepage{}
      \pal@standardpage{%
        \pal@backcovertemplate%
      }%
    \else
      \def\pal@currentbeforepage{}
      \pal@standardpage{
        \pal@backcovercontent
      }
    \fi
  \else
    \ifpal@haspages
      \ifpal@fanfold
        \ifpal@isfanfoldopen
          \ifpal@beginleft
            \pal@standardpage[before page=]{}
          \else
            \pal@emptypage
          \fi
        \else
          \ifpal@beginleft
          \else
            \pal@standardpage[before page=]{}
            \pal@emptypage
          \fi
        \fi
      \else
        \ifpal@haslastemptypage
          \ifpal@hasoddnumberofpages
            \pal@standardpage[before page=]{}
            \pal@emptypage
          \else
            \pal@emptypage
          \fi
        \else
          \ifpal@twoside
            \ifpal@hasoddnumberofpages\pal@standardpage[before page=]{}\fi
          \fi
        \fi
      \fi
    \fi
  \fi
  \ifpal@isbatchmode
    \pal@batchoptimize
  \fi
}

% scripts
\newread\pal@scriptresult
\def\pal@batchlist{}
\def\pal@ok{ok}
\def\pal@err@shellaccessforbidden{errorshellaccessforbidden}
\def\pal@err@importdirnotfound{errorimportdirnotfound}
\def\pal@err@noimportdir{errornoimportdir}
\def\pal@err@magicknotinstalled{errormagicknotinstalled}
\def\pal@err@inkscapenotinstalled{errorinkscapenotinstalled}
\newcommand\pal@getppi[1]{
  \immediate\openin\pal@scriptresult={|pagelayoutapi \ifdim\pal@originalgraphicwidth<\pal@originalgraphicheight getwidth\else getheight\fi\% "#1"}
  \ifeof\pal@scriptresult
    \pal@errmsg@shellaccessforbidden{Ppi not calculated}
  \else
    \endlinechar=-1
    \read\pal@scriptresult to \pal@graphicsize
    \endlinechar=13
    \ifx\pal@graphicsize\pal@emptystring
      \pal@errmsg@shellaccessfailed{Ppi not calculated}
    \else
      \ifx\pal@graphicsize\pal@err@magicknotinstalled
        \pal@errmsg@magicknotinstalled{Ppi not calculated}
      \else
        \ifdim\pal@originalgraphicwidth<\pal@originalgraphicheight
          \pgfmathqparse{(\pal@originalgraphicwidth - \pal@cropleft - \pal@cropright) / \pal@originalgraphicwidth * \pal@graphicsize pt / \the\width * 72.27pt}
        \else
          \pgfmathqparse{(\pal@originalgraphicheight - \pal@croptop - \pal@cropbottom) / \pal@originalgraphicheight * \pal@graphicsize pt / \the\height * 72.27pt}
        \fi

        \pgfmathint{\pgfmathresult}
        \edef\pal@graphicdensity{\pgfmathresult}
      \fi
    \fi
  \fi
  \immediate\closein\pal@scriptresult
}
\newcommand\pal@optimizegraphic[2]{
  \immediate\openin\pal@scriptresult={|pagelayoutapi optimize\% "#1#2" \% "\pal@filename" \%\pal@optimizedext\%\the\numexpr\pal@originalgraphicwidth\%\the\numexpr\pal@originalgraphicheight\%\the\numexpr\pal@cropleft\%\the\numexpr\pal@cropright\%\the\numexpr\pal@croptop\%\the\numexpr\pal@cropbottom\%\the\numexpr\pal@density\%\the\numexpr\width\%\the\numexpr\height\%\pal@downsamplethreshold\%\pal@graphicoptionunsharp\%\pal@quality}
  \ifeof\pal@scriptresult
    \pal@errmsg@shellaccessforbidden{File not optimized}
  \else
    \endlinechar=-1
    \read\pal@scriptresult to \pal@processresult
    \endlinechar=13
    \ifx\pal@processresult\pal@emptystring
      \pal@errmsg@shellaccessfailed{File not optimized}
    \else
      \ifx\pal@processresult\pal@err@magicknotinstalled
        \pal@errmsg@magicknotinstalled{File not optimized}
      \fi
    \fi
  \fi
  \immediate\closein\pal@scriptresult
}
\newcommand\pal@makeshadow[1]{
  \immediate\openin\pal@scriptresult={|pagelayoutapi makeshadow\%#1\%\pal@defaultshadowsize\%\pal@defaultshadowopacity\%\pal@defaultshadowcolor\%\the\pal@frameshadowwidth\%\the\pal@frameshadowheight\%\the\pal@frameshadowframewidth\%\the\pal@frameshadowframeheight\%\the\pal@frameshadowborder\%\the\pal@frameshadowradius}
  \ifeof\pal@scriptresult
    \edef\pal@processresult{\pal@err@shellaccessforbidden}
    \pal@errmsg@shellaccessforbidden{Shadow not created}
  \else
    \endlinechar=-1
    \read\pal@scriptresult to \pal@processresult
    \endlinechar=13
    \ifx\pal@processresult\pal@emptystring
      \pal@errmsg@shellaccessfailed{Shadow not created}
    \else
      \ifx\pal@processresult\pal@err@inkscapenotinstalled
        \pal@errmsg@inkscapenotinstalled{Shadow not created}
      \else
      \fi
    \fi
  \fi
  \immediate\closein\pal@scriptresult
}
\def\pal@start{
  \immediate\openin\pal@scriptresult={|pagelayoutapi start\ifpal@import\%import\% "\ifdefined\Ginput@path\Ginput@path\fi" \fi\ifpal@isturbomode\%turbo\% "\jobname" \fi}
  \ifeof\pal@scriptresult
    \ifpal@import
      \pal@errmsg@shellaccessforbidden{Import not working}
    \fi
  \else
    \endlinechar=-1
    \read\pal@scriptresult to \pal@processresult
    \endlinechar=13
    \ifx\pal@processresult\pal@emptystring
      \ifpal@import
        \pal@errmsg@shellaccessfailed{Import not working}
      \fi
    \else
      \ifx\pal@processresult\pal@ok
      \else
        \ifx\pal@processresult\pal@err@noimportdir
          \pal@errmsg@noimportdir
        \else
          \pal@errmsg@importdirnotfound{\pal@processresult}
        \fi
      \fi
    \fi
  \fi
  \immediate\closein\pal@scriptresult
}
\newcommand\pal@addtobatchlist[2]{
  \global\edef\pal@batchlist{\pal@batchlist\% "#1#2" \% "\pal@filename" \%\pal@optimizedext\%\the\numexpr\pal@originalgraphicwidth\%\the\numexpr\pal@originalgraphicheight\%\the\numexpr\pal@cropleft\%\the\numexpr\pal@cropright\%\the\numexpr\pal@croptop\%\the\numexpr\pal@cropbottom\%\the\numexpr\pal@density\%\the\numexpr\width\%\the\numexpr\height\%\pal@downsamplethreshold\%\pal@graphicoptionunsharp\%\pal@quality}
}
\newcommand\pal@batchoptimize{
  \immediate\openin\pal@scriptresult={|pagelayoutapi batchoptimize\pal@batchlist}
  \ifeof\pal@scriptresult
  \else
    \endlinechar=-1
    \read\pal@scriptresult to \pal@processresult
    \endlinechar=13
  \fi
  \immediate\closein\pal@scriptresult
}

% errors
\def\pal@errmsg@undefined#1#2{
  \ifx#2\pal@emptystring
  \else
    \ClassError{pagelayout}{Undefined #1 `#2'}{Check the name `#2'.\MessageBreak\MessageBreak\@ehc}
  \fi
}
\def\pal@errmsg@backcoverdefinedafterfrontcover{
  \ClassError{pagelayout}{Back cover needs to be defined before front cover}{Define the back cover before the front cover.\MessageBreak\MessageBreak\@ehc}
}
\def\pal@errmsg@shellaccessforbidden#1{
  \ClassError{pagelayout}{Shell access forbidden. #1}{Make sure `pagelayoutapi' is added to the list of shell escape commands\MessageBreak(shell_escape_commands = pagelayoutapi) in your `texmf.cnf'.\MessageBreak\MessageBreak\@ehc}
}
\def\pal@errmsg@shellaccessfailed#1{
  \ClassError{pagelayout}{Shell access failed. #1}{Make sure the `scripts' folder is added to your path.\MessageBreak\MessageBreak\@ehc}
}
\def\pal@errmsg@inkscapenotinstalled#1{
  \ClassError{pagelayout}{Inkscape not installed. #1}{Make sure Inkscape is installed.\MessageBreak\MessageBreak\@ehc}
}
\def\pal@errmsg@magicknotinstalled#1{
  \ClassError{pagelayout}{ImageMagick not installed. #1}{Make sure ImageMagick is installed.\MessageBreak\MessageBreak\@ehc}
}
\def\pal@errmsg@importdirnotfound#1{
  \ClassError{pagelayout}{Import directory `#1' not found}{Create the directory `#1'.\MessageBreak\MessageBreak\@ehc}
}
\def\pal@errmsg@noimportdir{
  \ClassError{pagelayout}{Import directory not found}{Create the directory `import' in your working directory\MessageBreak or define the shell variable `PAGELAYOUT_IMPORT_DIRECTORY'.\MessageBreak\MessageBreak\@ehc}
}
\def\pal@errmsg@lowdensity#1#2#3{
  \ifnum#1=0
    \ClassWarning{pagelayout}{The file `#2' has a low pixel density of #3 ppi}
  \else
    \ClassError{pagelayout}{The file `#2' has a very low a pixel density of #3 ppi}{Replace the image with one of higher resolution or reduce the display size.\MessageBreak\MessageBreak\@ehc}
  \fi
}
