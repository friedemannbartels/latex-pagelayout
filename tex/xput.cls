%%
%% Copyright (C) 2022 by Friedemann Bartels
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
\ProvidesClass{xput}[2023/01/02 declarative desktop publishing]
\def\Xputversion{1.0.2}

% packages
\RequirePackage{pgfopts}
\RequirePackage{tikz}
\RequirePackage{tcolorbox}
\tcbuselibrary{magazine}

% helper
\def\xput@emptystring{}
\def\xput@striplastexclamationmark#1{\xput@striplastexclamationmarka{#1}#1\end !\end\eend}
\def\xput@striplastexclamationmarka#1#2!\end#3\eend{\ifx\end#3\end#1\else#2\fi}
\def\xput@instring#1#2{TT\fi\begingroup\edef\xput@x{\endgroup\noexpand\in@{#1}{#2}}\xput@x\ifin@}
\def\xput@dimentonumber#1{\strip@pt\dimexpr #1*65536/\number\dimexpr 1\unitlength}

% ifs
\newif\ifxput@leftpage
\newif\ifxput@rightpage

\newif\ifxput@twoside
\newif\ifxput@fanfold
\newif\ifxput@cover
\newif\ifxput@beginleft
\newif\ifxput@beginright
\newif\ifxput@grid
\newif\ifxput@preflight
\newif\ifxput@graphpaper
\newif\ifxput@placeholder
\newif\ifxput@safezone
\newif\ifxput@cuttingmarks
\newif\ifxput@fillpages
\newif\ifxput@frontcover
\newif\ifxput@backcover

\newif\ifxput@hascover
\newif\ifxput@haspages
\newif\ifxput@isdoublepage
\newif\ifxput@ispage
\newif\ifxput@isemptypage
\newif\ifxput@haslastemptypage
\newif\ifxput@hasoddnumberofpages
\newif\ifxput@cuttingmarksvisible
\newif\ifxput@isfanfoldopen
\newif\ifxput@isinitgrid
\newif\ifxput@haspagegraphic
\newif\ifxput@isperformancemode
\newif\ifxput@isturbomode
\newif\ifxput@isbatchmode
\newif\ifxput@ismaskrequired
\newif\ifxput@optimize
\newif\ifxput@import
\newif\ifxput@isluatex

% dimensions
\newdimen\xput@null\xput@null=0pt
\newdimen\xput@undefdim\xput@undefdim=-1sp

\ifdefined\pagewidth\xput@isluatextrue\else\newdimen\pagewidth\newdimen\pageheight\fi
\newdimen\bleed\newdimen\outerbleed\newdimen\innerbleed\newdimen\topbleed\newdimen\bottombleed
\newdimen\safetymargin\newdimen\topsafetymargin\newdimen\bottomsafetymargin\newdimen\innersafetymargin\newdimen\outersafetymargin
\newdimen\innermargin\newdimen\bottommargin\newdimen\outermargin\newdimen\margin
\newdimen\gutter\newdimen\spinewidth\newdimen\bindingoffset
\newdimen\coverwidth\newdimen\coverheight
\newdimen\coverbleed\newdimen\coverouterbleed\newdimen\coverinnerbleed\newdimen\covertopbleed\newdimen\coverbottombleed
\newdimen\coversafetymargin\newdimen\covertopsafetymargin\newdimen\coverbottomsafetymargin\newdimen\coverinnersafetymargin\newdimen\coveroutersafetymargin

\newdimen\xput@pagewidth\newdimen\xput@pageheight
\newdimen\xput@outerbleed\newdimen\xput@innerbleed\newdimen\xput@topbleed\newdimen\xput@bottombleed
\newdimen\xput@topsafetymargin\newdimen\xput@bottomsafetymargin\newdimen\xput@innersafetymargin\newdimen\xput@outersafetymargin
\newdimen\xput@topmargin\newdimen\xput@topmargintmp\newdimen\xput@innermargin\newdimen\xput@bottommargin\newdimen\xput@outermargin
\newdimen\xput@gutter
\newdimen\xput@x\newdimen\xput@y\newdimen\xput@xx\newdimen\xput@yy\newdimen\width\newdimen\height\newdimen\x\newdimen\y
\newdimen\xput@gridoffsethorizontal\newdimen\xput@gridoffsetvertical\newdimen\xput@gridoffsethorizontaln\newdimen\xput@gridoffsetverticaln
\newdimen\xput@graphpaperx\newdimen\xput@graphpapery\newdimen\xput@graphpaperoffset\newdimen\xput@graphpapersnap

% interface
\newcommand\ifleftpage[1]{\ifxput@leftpage#1\fi}
\newcommand\ifrightpage[1]{\ifxput@rightpage#1\fi}
\newcommand\ifspine[1]{\ifxput@cover#1\fi}
\def\twoside{\xput@twosidetrue}
\def\fanfold{\xput@fanfoldtrue}
\def\cover{\xput@covertrue}
\def\beginleft{\xput@beginlefttrue}
\def\beginright{\xput@beginrighttrue}
\def\grid{\xput@gridtrue}\def\nogrid{\xput@gridfalse}
\def\preflight{\xput@preflighttrue}\def\nopreflight{\xput@preflightfalse}
\def\graphpaper{\xput@graphpapertrue}\def\nographpaper{\xput@graphpaperfalse}
\def\placeholders{\xput@placeholdertrue}\def\noplaceholders{\xput@placeholderfalse}
\def\safezone{\xput@safezonetrue}\def\nosafezone{\xput@safezonefalse}
\def\cuttingmarks{\xput@cuttingmarkstrue}\def\nocuttingmarks{\xput@cuttingmarksfalse}
\def\fillpages{\xput@fillpagestrue}\def\nofillpages{\xput@fillpagesfalse}
\newcommand\optimize[1][]{\xput@optimizetrue\pgfkeys{optimize,#1}}
\def\density#1{\def\xput@density{#1}}
\def\quality#1{\def\xput@quality{#1}}
\def\import{\xput@importtrue}

\def\setgraphpaper#1{
  \def\xput@graphpaperconfig{#1}
  \foreach \xput@graphpaperconfigitem in \xput@graphpaperconfig {
    \global\xput@graphpapersnap=\xput@graphpaperconfigitem
  }
}
\setgraphpaper{1mm,5mm}

\def\xput@pagecolormodel{}
\def\xput@pagecolor{}
\renewcommand\pagecolor[2][]{
  \ifxput@ispage
    \def\xput@pagecolormodel{#1}
    \def\xput@pagecolor{#2}
  \else
    \global\def\xput@pagecolormodel{#1}
    \global\def\xput@pagecolor{#2}
  \fi
}
\newcommand\setpagecolor[2][]{\pagecolor[#1]{#2}}
\def\nopagecolor{\pagecolor{}}

\def\xput@current@color{black}
\let\xput@originalcolor\color
\def\color#1{\ifxput@ispage\ifx\xput@current@color#1\else\def\xput@current@color{#1}\xput@originalcolor{#1}\fi\else\def\xputoptions@color{#1}\fi}
\def\setcolor#1{\color{#1}}

\let\xput@originalpagenumbering\pagenumbering
\newif\ifxput@pagenumberinghaschanged
\renewcommand\pagenumbering[1]{\xput@pagenumberinghaschangedtrue\xput@originalpagenumbering{#1}}

% options
\def\xput@density{300}
\def\xput@downsamplethreshold{120}
\def\xput@quality{}
\def\xput@unsharp{2x1}
\pgfkeysdef{/optimize/downsample threshold}{
  \pgfmathqparse{#1pt*100pt}
  \pgfmathround{\pgfmathresult}
  \pgfmathint{\pgfmathresult}
  \edef\xput@downsamplethreshold{\pgfmathresult}
}
\pgfkeys{
  /optimize/.is family,
  /optimize,
  density/.store in=\xput@density,
  quality/.store in=\xput@quality,
  unsharp/.store in=\xput@unsharp,
}
\pgfkeys{
  /xput/.cd,
  % page dimensions
  pagewidth/.code={\setlength{\pagewidth}{#1}},pagewidth=210mm,
  pageheight/.code={\setlength{\pageheight}{#1}},pageheight=297mm,
  bleed/.code={\setlength{\bleed}{#1}},bleed=0pt,
  outerbleed/.code={\setlength{\outerbleed}{#1}},outerbleed=\xput@undefdim,
  innerbleed/.code={\setlength{\innerbleed}{#1}},innerbleed=\xput@undefdim,
  topbleed/.code={\setlength{\topbleed}{#1}},topbleed=\xput@undefdim,
  bottombleed/.code={\setlength{\bottombleed}{#1}},bottombleed=\xput@undefdim,
  safetymargin/.code={\setlength{\safetymargin}{#1}},safetymargin=0pt,
  outersafetymargin/.code={\setlength{\outersafetymargin}{#1}},outersafetymargin=\xput@undefdim,
  innersafetymargin/.code={\setlength{\innersafetymargin}{#1}},innersafetymargin=\xput@undefdim,
  topsafetymargin/.code={\setlength{\topsafetymargin}{#1}},topsafetymargin=\xput@undefdim,
  bottomsafetymargin/.code={\setlength{\bottomsafetymargin}{#1}},bottomsafetymargin=\xput@undefdim,
  % cover dimensions
  coverwidth/.code={\setlength{\coverwidth}{#1}},coverwidth=\xput@undefdim,
  coverheight/.code={\setlength{\coverheight}{#1}},coverheight=\xput@undefdim,
  coverbleed/.code={\setlength{\coverbleed}{#1}},coverbleed=\xput@undefdim,
  coverouterbleed/.code={\setlength{\coverouterbleed}{#1}},coverouterbleed=\xput@undefdim,
  coverinnerbleed/.code={\setlength{\coverinnerbleed}{#1}},coverinnerbleed=\xput@undefdim,
  covertopbleed/.code={\setlength{\covertopbleed}{#1}},covertopbleed=\xput@undefdim,
  coverbottombleed/.code={\setlength{\coverbottombleed}{#1}},coverbottombleed=\xput@undefdim,
  coversafetymargin/.code={\setlength{\coversafetymargin}{#1}},coversafetymargin=\xput@undefdim,
  coveroutersafetymargin/.code={\setlength{\coveroutersafetymargin}{#1}},coveroutersafetymargin=\xput@undefdim,
  coverinnersafetymargin/.code={\setlength{\coverinnersafetymargin}{#1}},coverinnersafetymargin=\xput@undefdim,
  covertopsafetymargin/.code={\setlength{\covertopsafetymargin}{#1}},covertopsafetymargin=\xput@undefdim,
  coverbottomsafetymargin/.code={\setlength{\coverbottomsafetymargin}{#1}},coverbottomsafetymargin=\xput@undefdim,
  spinewidth/.code={\setlength{\spinewidth}{#1}},spinewidth=3mm,
  bindingoffset/.code={\setlength{\bindingoffset}{#1}},bindingoffset=0pt,
  % grid dimensions
  margin/.code={\setlength{\margin}{#1}},margin=20mm,
  outermargin/.code={\setlength{\outermargin}{#1}},outermargin=\xput@undefdim,
  innermargin/.code={\setlength{\innermargin}{#1}},innermargin=\xput@undefdim,
  topmargin/.store in=\xputoptions@topmargin,topmargin=-1sp,
  bottommargin/.code={\setlength{\bottommargin}{#1}},bottommargin=\xput@undefdim,
  gutter/.code={\setlength{\gutter}{#1}},gutter=0pt,
  pagecolor/.store in=\xput@pagecolor,
  pagegraphic/.store in=\xputoptions@pagegraphic,pagegraphic=,
  color/.store in=\xputoptions@color,color=black,
  grid/.is if=xput@grid,
  safezone/.is if=xput@safezone,
  cuttingmarks/.is if=xput@cuttingmarks,
  graphpaper/.is if=xput@graphpaper,
  placeholder/.is if=xput@placeholder,
  fillpages/.is if=xput@fillpages,
  draft/.code={\xput@placeholdertrue\xput@fillpagestrue\xput@cuttingmarkstrue\xput@isperformancemodetrue},
  preflight/.is if=xput@preflight,
  twoside/.is if=xput@twoside,
  fanfold/.code={\xput@fanfoldtrue\xput@covertrue\xput@twosidetrue\xput@beginlefttrue},
  cover/.is if=xput@cover,
  beginleft/.is if=xput@beginleft,
  beginright/.is if=xput@beginright,
  optimize/.code={\xput@optimizetrue\pgfkeys{optimize,#1}},
  density/.store in=\xput@density,
  quality/.store in=\xput@quality,
  turbo/.is if=xput@isturbomode,turbo=\ifxput@isluatex false\else true\fi,
  import/.is if=xput@import
}
\ProcessPgfOptions{/xput}

\xput@originalcolor{\xputoptions@color}

\Gin@draftfalse

\LoadClass[multi=picture]{standalone}
\setlength{\topmargin}{\xputoptions@topmargin}

% grid
\newdimen\xput@gridoffsetx
\newdimen\xput@gridwidth\newdimen\xput@gridheight\newdimen\xput@maxgridheight\newdimen\xput@maxgridwidth
\newcount\xput@gridtmp\newcount\xput@gridtmpRowH
\newcount\xput@rowscount\newcount\xput@flexrowscount\newcount\xput@fixrowscount\newcount\xput@cellscount
\newcount\rowsH\newcount\rowsF\newcount\rowsFlex
\newif\ifxput@gridisflexrow
\def\xput@set#1#2{
  \ifcsname xput@data#1\endcsname
  \else
    \expandafter\newcount\csname xput@data#1\endcsname
  \fi
  \csname xput@data#1\endcsname#2\relax
}
\def\xput@get#1{
  \ifcsname xput@data#1\endcsname
    \csname xput@data#1\endcsname%
  \else
    0
  \fi
}
\def\xput@advance#1#2{
  \advance\csname xput@data#1\endcsname by \csname xput@data#2\endcsname
}
\newif\ifxput@flexmode
\newif\ifxput@forcerow
\newif\ifxput@forcecell
\def\xput@leftsafetymargin{
  \ifxput@backcover%
    \xput@outersafetymargin%
  \else%
    \ifxput@frontcover%
      \xput@innersafetymargin%
    \else%
      \ifxput@leftpage%
        \xput@outersafetymargin%
      \else%
        \xput@innersafetymargin%
      \fi%
    \fi%
  \fi%
}
\def\xput@rightsafetymargin{
  \ifxput@backcover%
    \xput@innersafetymargin%
  \else%
    \ifxput@frontcover%
      \xput@outersafetymargin%
    \else%
      \ifxput@leftpage%
        \xput@innersafetymargin%
      \else%
        \xput@outersafetymargin%
      \fi%
    \fi%
  \fi%
}
\def\xput@leftbleed{
  \ifxput@backcover%
    \xput@outerbleed%
  \else%
    \ifxput@frontcover%
      \xput@innerbleed%
    \else%
      \ifxput@leftpage%
        \xput@outerbleed%
      \else%
        \xput@innerbleed%
      \fi%
    \fi%
  \fi%
}
\def\xput@rightbleed{
  \ifxput@backcover%
    \xput@innerbleed%
  \else%
    \ifxput@frontcover%
      \xput@outerbleed%
    \else%
      \ifxput@leftpage%
        \xput@innerbleed%
      \else%
        \xput@outerbleed%
      \fi%
    \fi%
  \fi%
}
\def\xput@leftmargin{
  \ifxput@backcover%
    \xput@outermargin%
  \else%
    \ifxput@frontcover%
      \xput@innermargin%
    \else%
      \ifxput@leftpage%
        \xput@outermargin%
      \else%
        \xput@innermargin%
      \fi%
    \fi%
  \fi%
}
\newcommand\xput@addrow[1]{
  \advance\xput@rowscount by 1
  \xput@cells#1
}
\newdimen\xput@gridheightdiff
\newdimen\xput@gridwidthdiff
\newdimen\xput@gridstartxdim
\newdimen\xput@gridstartydim
\newcount\looprows
\newcount\loopcells
\newcommand\xput@processrows{
  \advance\looprows 1
  \ifnum\xput@get{if\the\looprows F}=1
    \xput@set{\the\looprows HR}{\numexpr(\xput@gridheight-\xput@gutter*\xput@rowscount)*\xput@get{\the\looprows H}/\rowsH+\xput@gutter}
  \else
    \ifnum\xput@get{if\the\looprows Fix}=0
      \xput@set{\the\looprows HR}{\numexpr(\xput@maxgridheight-\xput@gridheight)*\xput@get{\the\looprows H}/\rowsFlex+\xput@gutter}
    \else
      \xput@set{\the\looprows HR}{\numexpr(\xput@gridwidth-\xput@gutter*\xput@get{\the\looprows C})*\xput@get{\the\looprows H}/\xput@get{\the\looprows W}+\xput@gutter}
    \fi
  \fi
  \loopcells=0
  \loop
    \advance\loopcells 1
    \ifnum\xput@get{if\the\looprows-\the\loopcells F}=1
      \xput@set{\the\looprows-\the\loopcells WR}{\numexpr(\xput@get{\the\looprows HR}-\xput@gutter)*\xput@get{\the\looprows-\the\loopcells W}/\xput@get{\the\looprows H}+\xput@gutter}
    \else
      \xput@set{\the\looprows-\the\loopcells WR}{\numexpr((\xput@gridwidth-\xput@gutter*\xput@get{\the\looprows C})\ifnum\xput@get{\the\looprows H}>0 -(\xput@get{\the\looprows HR}-\xput@gutter)*\xput@get{\the\looprows F}/\xput@get{\the\looprows H}\fi)*\xput@get{\the\looprows-\the\loopcells W}/(\xput@get{\the\looprows W}-\xput@get{\the\looprows F})+\xput@gutter}
    \fi
  \ifnum \loopcells<\xput@get{\the\looprows C}
  \repeat

  \ifnum \looprows<\xput@rowscount
    \xput@processrows
  \fi
}
\newcommand\xput@closerows{
  \xput@topmargin=\ifdim\xput@gridtopmargin=\xput@undefdim\xput@gridmargin\else\xput@gridtopmargin\fi
  \xput@bottommargin=\ifdim\xput@gridbottommargin=\xput@undefdim\xput@gridmargin\else\xput@gridbottommargin\fi
  \xput@innermargin=\ifdim\xput@gridinnermargin=\xput@undefdim\xput@gridmargin\else\xput@gridinnermargin\fi
  \xput@outermargin=\ifdim\xput@gridoutermargin=\xput@undefdim\xput@gridmargin\else\xput@gridoutermargin\fi

  \height=\dimexpr\xput@pageheight - \xput@topmargin - \xput@bottommargin\relax
  \width=\dimexpr\xput@pagewidth - \xput@innermargin - \xput@outermargin\relax
  \ifdim\dimexpr\xput@gridoptionheight\relax=\xput@undefdim
  \else
    \xput@gridheightdiff=\dimexpr0.5\height - 0.5\dimexpr\xput@gridoptionheight\relax\relax
    \xput@bottommargin=\dimexpr\xput@bottommargin+\xput@gridheightdiff\relax
    \xput@topmargin=\dimexpr\xput@topmargin+\xput@gridheightdiff\relax
  \fi
  \ifdim\dimexpr\xput@gridoptionwidth\relax=\xput@undefdim
  \else
    \xput@gridwidthdiff=\dimexpr\xput@calculaterealgridwidth/2 - 0.5\dimexpr\xput@gridoptionwidth\relax\relax
    \xput@innermargin=\dimexpr\xput@innermargin+\xput@gridwidthdiff\relax
    \xput@outermargin=\dimexpr\xput@outermargin+\xput@gridwidthdiff\relax
  \fi

  \xput@gutter=\xput@gridgutter

  \x=\dimexpr\xput@gridstartx{\xput@undefdim}-\xput@leftbleed\relax
  \y=\dimexpr\xput@gridstarty{\xput@undefdim}-\xput@bottombleed\relax

  \xput@gridstartxdim=\dimexpr\xput@gridstartx{\xput@gridoptionx}\relax
  \xput@gridstartydim=\dimexpr\xput@gridstarty{\xput@gridoptiony}\relax

  \xput@gridwidth=\dimexpr\xput@calculatefullgridwidth\relax
  \ifnum\rowsH>0
    \xput@calculategridheight
  \else
    \xput@gridheight=\dimexpr\xput@gutter*\xput@rowscount\relax
  \fi
  \xput@gridoffsetvertical=\xput@null
  \xput@gridoffsethorizontal=\xput@null
  \xput@gridoffsetverticaln=\xput@null
  \xput@gridoffsethorizontaln=\xput@null

  \xput@maxgridheight=\dimexpr\xput@calculatefullgridheight\relax
  \ifdim\xput@gridheight>\xput@maxgridheight
    \xput@gridheight=\xput@maxgridheight
    \xput@calculategridwidth
    \xput@gridoffsethorizontal=\dimexpr\xput@gridoptionhpos\xput@gridwidth-\xput@gridoptionhpos\xput@maxgridwidth\relax
    \xput@gridoffsethorizontaln=\dimexpr\xput@gridwidth-\xput@maxgridwidth-\xput@gridoffsethorizontal\relax
    \xput@gridwidth=\xput@maxgridwidth
  \else
    \ifxput@flexmode
    \else
      \ifdim\xput@gridheight<\xput@maxgridheight
        \xput@gridoffsetvertical=\dimexpr\xput@gridoptionvpos\xput@maxgridheight-\xput@gridoptionvpos\xput@gridheight\relax
        \xput@gridoffsetverticaln=\dimexpr\xput@maxgridheight-\xput@gridheight-\xput@gridoffsetvertical\relax
      \fi
    \fi
  \fi

  \looprows=0
  \xput@processrows
}
\newcommand\xput@addcell[1]{
  \advance\xput@cellscount by 1
  \if\xput@instring{!}{#1}
    \xput@gridtmp \xput@striplastexclamationmark{#1}\relax
    \xput@forcecelltrue
  \else
    \xput@gridisflexrowtrue
    \ifnum\numexpr0#1\relax=0
      \xput@gridtmp 1\relax
    \else
      \xput@gridtmp #1\relax
    \fi
    \xput@forcecellfalse
  \fi
  \xput@set{\the\xput@rowscount-\the\xput@cellscount W}{\xput@gridtmp}
  \ifxput@forcecell
    \xput@set{if\the\xput@rowscount-\the\xput@cellscount F}{1}
    \xput@advance{\the\xput@rowscount F}{\the\xput@rowscount-\the\xput@cellscount W}
  \else
    \xput@set{if\the\xput@rowscount-\the\xput@cellscount F}{0}
  \fi
  \xput@advance{\the\xput@rowscount W}{\the\xput@rowscount-\the\xput@cellscount W}
}
\newif\ifxput@gridtop
\newif\ifxput@gridbottom
\newif\ifxput@gridleft
\newif\ifxput@gridright
\newif\ifxput@gridfull
\pgfkeys{
  /grid/.is family,
  /grid,
  gutter/.store in=\xput@gridgutter,
  margin/.store in=\xput@gridmargin,
  top margin/.store in=\xput@gridtopmargin,
  bottom margin/.store in=\xput@gridbottommargin,
  inner margin/.store in=\xput@gridinnermargin,
  outer margin/.store in=\xput@gridoutermargin,
  width/.store in=\xput@gridoptionwidth,
  height/.store in=\xput@gridoptionheight,
  x/.store in=\xput@gridoptionx,
  y/.store in=\xput@gridoptiony,
  vpos/.store in=\xput@gridoptionvpos,
  hpos/.store in=\xput@gridoptionhpos,
}
\def\xput@resetautogrid{
  \global\xput@gridfullfalse
  \def\xput@framey{0}\def\xput@framex{0}\def\xput@frameyy{1}\def\xput@framexx{1}
  \def\xput@frameyymax{0}\def\xput@framexxmax{0}
}
\newcommand\setgrid[2][]{
  \ifxput@haspages
  \else
    \def\xput@tmpgrid{\setgrid{#2}}
  \fi
  \xput@resetautogrid
  \pgfkeys{
    /grid,
    gutter=\gutter,
    margin=\margin,
    top margin=\topmargin,
    bottom margin=\bottommargin,
    inner margin=\innermargin,
    outer margin=\outermargin,
    width=\xput@undefdim,
    height=\xput@undefdim,
    x=\xput@undefdim,
    y=\xput@undefdim,
    vpos=\xput@verticalpagealign,
    hpos=\xput@horizontalpagealign,%
    #1
  }
  \rowsH 0\relax
  \rowsFlex 0\relax
  \xput@flexrowscount 0\relax
  \xput@fixrowscount 0\relax
  \rowsF 0\relax
  \xput@rowscount 0\relax
  \xput@flexmodefalse
  \def\xput@grid@input{#2}
  \ifx\xput@grid@input\xput@emptystring
    \xput@gobblenextrow{{1}}
  \else
    \xput@gobblenextrow#2
  \fi
}
\newcommand\xput@gobblenextrow[1]{
  \xput@addrow{#1}
  \@ifnextchar\bgroup{
    \xput@gobblenextrow
  }{
    \ifxput@isinitgrid
    \else
      \xput@closerows
    \fi
  }
}
\newcommand\xput@cells[2][1]{
  \if\xput@instring{!}{#1}
    \xput@gridtmpRowH \xput@striplastexclamationmark{#1}\relax
    \xput@forcerowtrue
    \advance\rowsF by \xput@gridtmpRowH
    \advance\rowsH by \xput@gridtmpRowH
    \xput@set{\the\xput@rowscount H}{\xput@gridtmpRowH}
    \advance \xput@fixrowscount by 1
  \else
    \xput@forcerowfalse
    \xput@gridtmpRowH #1\relax
  \fi

  \xput@cellscount 0\relax
  \xput@set{\the\xput@rowscount W}{0}
  \xput@set{\the\xput@rowscount F}{0}
  \ifxput@forcerow\xput@set{if\the\xput@rowscount F}{1}\else\xput@set{if\the\xput@rowscount F}{0}\fi
  \xput@gridisflexrowfalse

  \xput@gobblenextcell{#2}
}
\newcommand\xput@gobblenextcell[1]{
  \xput@addcell{#1}
  \@ifnextchar\bgroup{
    \xput@gobblenextcell
  }{
    \ifxput@forcerow
    \else
      \ifxput@gridisflexrow
        \xput@flexmodetrue
        \advance \xput@flexrowscount by 1
        \advance\rowsFlex by \xput@gridtmpRowH
        \xput@set{\the\xput@rowscount H}{\xput@gridtmpRowH}
        \xput@set{if\the\xput@rowscount Fix}{0}
      \else
        \advance \xput@fixrowscount by 1
        \advance\rowsH by \xput@gridtmpRowH
        \xput@set{\the\xput@rowscount H}{\xput@gridtmpRowH}
        \xput@set{if\the\xput@rowscount Fix}{1}
      \fi
    \fi
    \xput@set{\the\xput@rowscount C}{\xput@cellscount}
  }
}

% grid shortcut
\def\xput@flexkey{f}
\def\xput@portraitkey{p}
\def\xput@squarekey{s}
\def\xput@landscapekey{l}
\def\xput@goldenkey{g}
\def\xput@goldenuprightkey{o}
\def\xput@widekey{w}
\def\xput@rowbreakkey{-}
\newcount\xput@rowcountsc
\newcount\xput@cellcountsc
\newcommand\xput@breakrow{
  \edef\xput@result{\xput@result{[30]\xput@rowindex}}
}
\newif\ifxput@isgridvalid
\newcommand\xput@transformgridconfig[1]{
  \ifx\xput@rowbreakkey#1
    \xput@breakrow
    \def\xput@rowindex{}
  \else
    \ifx\xput@flexkey#1
      \edef\xput@rowindex{\xput@rowindex{1}}
    \else
      \ifx\xput@portraitkey#1
        \edef\xput@rowindex{\xput@rowindex{20!}}
      \else
        \ifx\xput@squarekey#1
          \edef\xput@rowindex{\xput@rowindex{30!}}
        \else
          \ifx\xput@landscapekey#1
            \edef\xput@rowindex{\xput@rowindex{45!}}
          \else
            \ifx\xput@widekey#1
              \edef\xput@rowindex{\xput@rowindex{60!}}
            \else
              \ifx\xput@goldenkey#1
                \edef\xput@rowindex{\xput@rowindex{50!}}
              \else
                \ifx\xput@goldenuprightkey#1
                  \edef\xput@rowindex{\xput@rowindex{18!}}
                \else
                  \xput@isgridvalidfalse
                \fi
              \fi
            \fi
          \fi
        \fi
      \fi
    \fi
  \fi
}
\newcommand\xput@setplaceholder[1]{
  \ifx\xput@rowbreakkey#1
    \advance\xput@rowcountsc by 1
    \xput@cellcountsc 0\relax
  \else
    \placeholder{{\xput@rowcountsc} {\xput@cellcountsc} {\numexpr\xput@rowcountsc+1\relax} {\numexpr\xput@cellcountsc+1\relax}}
    \advance\xput@cellcountsc by 1
  \fi
}
\newcommand\xput@gridsc[1]{
  \edef\xput@gridsc@input{#1}
  \def\xput@rowindex{}
  \def\xput@result{}
  \xput@isgridvalidtrue
  \@tfor\next:=#1\do{\xput@transformgridconfig{\next}}%
  \ifxput@isgridvalid
    \xput@breakrow
    \edef\xput@result{{\xput@result}}
    \expandafter\setgrid\xput@result
    \xput@rowcountsc 0\relax
    \xput@cellcountsc 0\relax
    \@tfor\next:=#1\do{\xput@setplaceholder{\next}}%
  \else
    \xput@errmsg@undefined{template}{\xput@gridsc@input}
  \fi
}

% grid dimensions
\newif\ifxput@flexgrid
\newcommand\xput@calculategridheight{
  \xput@flexgridtrue
  \xput@gridheight=\xput@null
  \looprows=0
  \loop
    \advance\looprows 1
    \ifnum\xput@get{if\the\looprows F}=1
      \xput@gridheight=\dimexpr\xput@gridheight+\xput@gutter\relax%
    \else
      \ifnum\xput@get{if\the\looprows Fix}=0
        \xput@gridheight=\dimexpr\xput@gridheight+\xput@gutter\relax%
      \else
        \xput@flexgridfalse
        \xput@gridheight=\dimexpr\xput@gridheight+(\xput@gridwidth-\xput@gutter*\xput@get{\the\looprows C})*\xput@get{\the\looprows H}/(\xput@get{\the\looprows W}*(\rowsH-\rowsF))*\rowsH+\xput@gutter\relax
      \fi
    \fi
  \ifnum \looprows<\xput@rowscount
  \repeat
  \ifxput@flexgrid
    \xput@gridheight=\dimexpr\xput@calculatefullgridheight\relax
  \fi
}
\newcommand\xput@calculatefullgridheight{
  \xput@pageheight - \xput@topmargin - \xput@bottommargin + \xput@gutter
}
\newcommand\xput@calculategridwidth{
  \def\xput@calculategridwidthcalc{(\xput@gridheight*(\rowsH-\rowsF)/\rowsH-\xput@gutter*(\rowsH-\rowsF)*\xput@rowscount/\rowsH}
  \looprows=0
  \loop
    \advance\looprows 1
    \ifnum\xput@get{if\the\looprows F}=1
    \else
      \ifnum\xput@get{if\the\looprows Fix}=0
      \else
        \edef\xput@calculategridwidthcalc{\xput@calculategridwidthcalc+\xput@gutter*\xput@get{\the\looprows C}*\xput@get{\the\looprows H}/\xput@get{\the\looprows W}}
      \fi
    \fi
  \ifnum \looprows<\xput@rowscount
  \repeat

  \edef\xput@calculategridwidthcalc{\xput@calculategridwidthcalc) * 10000 / (\xput@null}
  \looprows=0
  \loop
    \advance\looprows 1
    \ifnum\xput@get{if\the\looprows F}=1
    \else
      \ifnum\xput@get{if\the\looprows Fix}=0
      \else
        \edef\xput@calculategridwidthcalc{\xput@calculategridwidthcalc+10000*\xput@get{\the\looprows H}/\xput@get{\the\looprows W}}
      \fi
    \fi
  \ifnum \looprows<\xput@rowscount
  \repeat

  \edef\xput@calculategridwidthcalc{\xput@calculategridwidthcalc)}
  \xput@maxgridwidth=\dimexpr\xput@calculategridwidthcalc\relax
}
\newcommand\xput@calculatefullgridwidth{
  \ifxput@isdoublepage
    \xput@pagewidth * 2 - \xput@outermargin * 2
    \ifxput@frontcover
    \else
      \ifxput@fanfold
      \else
        - \bindingoffset * 2
      \fi
    \fi
  \else
    \xput@pagewidth - \xput@innermargin - \xput@outermargin
  \fi
  + \xput@gutter
}
\newcommand\xput@calculaterealgridwidth{
  \ifxput@isdoublepage
    (\xput@pagewidth * 2 - \xput@outermargin * 2)
  \else
    (\xput@pagewidth - \xput@innermargin - \xput@outermargin)
  \fi
}
\newcommand\xput@gridstartx[1]{
  \ifdim\dimexpr#1\relax=\xput@undefdim
    \ifxput@isdoublepage
      (\xput@outermargin + \xput@leftbleed - \xput@gutter / 2
      \ifxput@frontcover
      \else
        \ifxput@fanfold
        \else
          \ifxput@rightpage
            + \bindingoffset * 2
          \fi
        \fi
      \fi
      )
    \else
      (\xput@leftmargin + \xput@leftbleed - \xput@gutter / 2)
    \fi
  \else%
    \ifxput@isdoublepage
      (#1 + \xput@leftbleed - \xput@gutter / 2
      \ifxput@frontcover
      \else
        \ifxput@fanfold
        \else
          \ifxput@rightpage
            + \bindingoffset * 2
          \fi
        \fi
      \fi
      )
    \else
      (#1 + \xput@leftbleed - \xput@gutter / 2)
    \fi
  \fi%
}
\newcommand\xput@gridstarty[1]{
  \ifdim\dimexpr#1\relax=\xput@undefdim
    (\xput@bottommargin + \xput@bottombleed - \xput@gutter / 2)%
  \else%
    (#1 + \xput@bottombleed - \xput@gutter / 2)
  \fi%
}
\newcommand\xput@setdimensions{
  \global\xput@gridfullfalse
  \global\def\xput@framey{0}\global\def\xput@framex{0}\global\def\xput@frameyy{1}\global\def\xput@framexx{1}
  \global\def\xput@frameyymax{0}\global\def\xput@framexxmax{0}
  \paperheight=\dimexpr(\xput@pageheight + \xput@topbleed + \xput@bottombleed)\relax
  \xput@gridoffsetx=\xput@null

  \ifxput@isdoublepage
    % doublepage
    \ifxput@fanfold
      \paperwidth=\dimexpr((\xput@pagewidth + \xput@outerbleed) * 2)\relax
    \else
      \paperwidth=\dimexpr(\xput@pagewidth + \xput@outerbleed + \xput@innerbleed)\relax
      \ifxput@rightpage
        \xput@gridoffsetx=\dimexpr(-\xput@pagewidth)\relax
      \fi
    \fi
  \else
    \ifxput@frontcover
      % frontcover
      \paperwidth=\dimexpr((\xput@pagewidth + \xput@outerbleed) * 2 + \spinewidth)\relax
    \else
      % page
      \ifxput@fanfold
        \paperwidth=\dimexpr((\xput@pagewidth + \xput@outerbleed) * 2)\relax
        \ifxput@rightpage
          \xput@gridoffsetx=\dimexpr(\xput@pagewidth + \xput@outerbleed - \xput@innerbleed)\relax
        \fi
      \else
        \paperwidth=\dimexpr(\xput@pagewidth + \xput@outerbleed + \xput@innerbleed)\relax
      \fi
    \fi
  \fi
}

% grid coordinates
\newcommand\xput@coordxrow[3]{\ifdim\dimexpr#2\dimexpr1pt\relax\relax<\dimexpr(#3\dimexpr1pt\relax-#1sp)\relax\the\numexpr#3\relax\else\xput@coordxrow{#1}{#2}{\numexpr#3+1\relax}\fi}
\newcommand\xput@coordxcell[2]{\ifnum\numexpr(10000*#1)\relax<\numexpr(#2*10000+1)\relax\the\numexpr#2\relax\else\xput@coordxcell{#1}{\numexpr#2+1\relax}\fi}
\newcommand\xput@coordx[3]{
  \xput@get{%
    \xput@coordxrow{#1}{#2}{1}-%
    \xput@coordxcell{#3}{1}%
    WR%
  }
}
\newcommand\posxcell[3]{
  \ifnum#3>0
    + \xput@coordx{#1}{#2}{#3}sp%
  \fi%
  \ifnum#3>1
    \posxcell{#1}{#2}{\numexpr#3-1\relax}%
  \fi%
}
\newcommand\posxrow[4]{
  \ifdim#4\dimexpr1pt\relax<\dimexpr#3\dimexpr1pt\relax+1sp\relax
    \xput@gridstartxdim + #4\dimexpr\xput@coordx{#1}{#2}{#3}sp\relax - \xput@coordx{#1}{#2}{#3}sp * \numexpr#3 - 1\relax\posxcell{#1}{#2}{\numexpr#3-1\relax}%
  \else%
    \posxrow{#1}{#2}{\numexpr#3+1\relax}{#4}%
  \fi%
}
\newcommand\posx[4]{
  \dimexpr(%
    \posxrow{#1}{#2}{1}{#4}
    + #3\xput@gutter / 2 + \xput@gridoffsetx + \xput@gridoffsethorizontal%
  )\relax%
}
\newcommand\posycell[1]{
  \ifnum#1>0
    - \xput@get{#1HR} sp
  \fi%
  \ifnum#1>1
    \posycell{\the\numexpr#1-1\relax}%
  \fi%
}
\newcommand\posyrow[2]{
  \ifdim#1\dimexpr1pt\relax<\dimexpr#2\dimexpr1pt\relax+1sp\relax
      \xput@gridstartydim + \xput@maxgridheight - #1\dimexpr\xput@get{#2HR} sp\relax + \xput@get{#2HR} sp * \numexpr#2 - 1\relax\posycell{\the\numexpr#2-1\relax}%
  \else
    \posyrow{#1}{\the\numexpr#2+1\relax}%
  \fi
}
\newcommand\posy[2]{
  \dimexpr(%
    \posyrow{#2}{1}
    - #1\xput@gutter / 2 - \xput@gridoffsetvertical%
  )\relax%
}
\newcommand\xput@gridhalign[1]{
  \def\xput@horizontalpagealign{#1}
}
\newcommand\xput@gridvalign[1]{
  \def\xput@verticalpagealign{#1}
}
\xput@gridhalign{0.5}
\xput@gridvalign{0.5}
\xput@isinitgridtrue
\setgrid{{{1}}}

% graphic
\newif\ifxput@isvisible
\newif\ifxput@calculatecrop
\newdimen\xput@originalgraphicwidth\newdimen\xput@originalgraphicheight
\newdimen\xput@cropx\newdimen\xput@cropy
\newdimen\xput@cropleft\newdimen\xput@cropright
\newdimen\xput@cropbottom\newdimen\xput@croptop
\newdimen\xput@cropstart\newdimen\xput@cropend
\newdimen\xput@snapleft\newdimen\xput@snapright
\newdimen\xput@snapbottom\newdimen\xput@snaptop
\newdimen\xput@viewportwidth\newdimen\xput@viewportheight
\newdimen\xput@frameborderwidth
\newdimen\xput@frameborderradius
\newdimen\xput@frameshadowradius
\newdimen\xput@snapcroptmp
\newdimen\xput@overprint
\xput@overprint=0pt
\def\xput@cropleftside{
  \ifdim\xput@x>\xput@cropstart
    \ifdim\xput@x<\xput@cropend
      \xput@snapleft=\dimexpr(\xput@x - \xput@cropstart)\relax
      \xput@x=\dimexpr(\xput@cropstart)\relax
    \fi
  \fi
}
\def\xput@croprightside{
  \ifdim\xput@xx>\xput@cropstart
    \ifdim\xput@xx<\xput@cropend
      \xput@snapright=\dimexpr(\xput@cropend - \xput@xx)\relax
      \xput@xx=\dimexpr(\xput@cropend)\relax
    \fi
  \fi
}
\def\xput@snapsafezonevertical{
  \xput@snapbottom=\xput@null
  \xput@snaptop=\xput@null
  \xput@cropstart=-\xput@overprint
  \xput@cropend=\dimexpr(\xput@null + \xput@bottombleed + 1pt)\relax
  \ifdim\xput@y>\xput@cropstart
    \ifdim\xput@y<\xput@cropend
      \xput@snapbottom=\dimexpr(\xput@y - \xput@cropstart)\relax
      \xput@y=\dimexpr(\xput@cropstart)\relax
    \fi
  \fi
  \xput@cropstart=\dimexpr(\xput@pageheight + \xput@bottombleed - 1pt)\relax
  \xput@cropend=\dimexpr(\xput@pageheight + \xput@bottombleed  + \xput@topbleed + \xput@overprint)\relax
  \ifdim\xput@yy>\xput@cropstart
    \ifdim\xput@yy<\xput@cropend
      \xput@snaptop=\dimexpr(\xput@cropend - \xput@yy)\relax
      \xput@yy=\dimexpr(\xput@cropend)\relax
    \fi
  \fi
}
\def\xput@snapsafezonehorizontal{
  \xput@snapleft=\xput@null
  \xput@snapright=\xput@null
  \ifxput@isdoublepage
    % doublepage
    \ifxput@fanfold
      \xput@cropstart=-\xput@overprint
      \xput@cropend=\dimexpr(\xput@null + \xput@leftbleed + 1pt)\relax
      \xput@cropleftside
      \xput@cropstart=\dimexpr(\xput@pagewidth * 2 + \xput@outerbleed - 1pt)\relax
      \xput@cropend=\dimexpr(\xput@pagewidth * 2 + \xput@outerbleed * 2 + \xput@overprint)\relax
      \xput@croprightside
    \else
      \xput@cropstart=-\xput@overprint
      \xput@cropend=\dimexpr(\xput@null + \xput@leftbleed + 1pt)\relax
      \xput@cropleftside
      \xput@cropstart=\dimexpr(\xput@pagewidth + \xput@outerbleed + \xput@innerbleed - \xput@rightbleed - 1pt)\relax
      \xput@cropend=\dimexpr(\xput@pagewidth + \xput@outerbleed + \xput@innerbleed + \xput@overprint)\relax
      \xput@croprightside
      \ifxput@leftpage
        \xput@cropstart=\dimexpr(\xput@pagewidth * 2 + \xput@outerbleed - \bindingoffset * 2 - 1pt)\relax
        \xput@cropend=\dimexpr(\xput@pagewidth * 2 + \xput@outerbleed + \xput@outerbleed - \bindingoffset * 2 + \xput@overprint)\relax
        \xput@croprightside
      \else
        \xput@cropstart=\dimexpr(\xput@innerbleed -\xput@pagewidth - \xput@outerbleed + \bindingoffset * 2 - \xput@overprint)\relax
        \xput@cropend=\dimexpr(-\xput@pagewidth + \xput@innerbleed + \bindingoffset * 2 + 1pt)\relax
        \xput@cropleftside
      \fi
    \fi
  \else
    % frontcover
    \ifxput@frontcover
      \ifxput@cover
        \ifxput@backcover
          \xput@cropstart=-\xput@overprint
          \xput@cropend=\dimexpr(\xput@null + \xput@leftbleed + 1pt)\relax
        \else
          \xput@cropstart=\dimexpr(\xput@pagewidth + \xput@outerbleed)\relax
          \xput@cropend=\dimexpr(\xput@pagewidth + \xput@outerbleed + \spinewidth + 1pt)\relax
        \fi
        \xput@cropleftside
        \ifxput@backcover
          \xput@cropstart=\dimexpr(\xput@pagewidth + \xput@outerbleed - 1pt)\relax
          \xput@cropend=\dimexpr(\xput@pagewidth + \xput@outerbleed)\relax
        \else
          \xput@cropstart=\dimexpr(\xput@pagewidth * 2 + \spinewidth + \xput@outerbleed - 1pt)\relax
          \xput@cropend=\dimexpr(\xput@pagewidth * 2 + \xput@outerbleed * 2 + \spinewidth + \xput@overprint)\relax
        \fi
        \xput@croprightside
      \else
        \xput@cropstart=-\xput@overprint
        \xput@cropend=\dimexpr(\xput@null + \xput@leftbleed + 1pt)\relax
        \xput@cropleftside
        \xput@cropstart=\dimexpr(\xput@pagewidth + \xput@outerbleed + \xput@innerbleed - \xput@rightbleed - 1pt)\relax
        \xput@cropend=\dimexpr(\xput@pagewidth + \xput@outerbleed + \xput@innerbleed + \xput@overprint)\relax
        \xput@croprightside
      \fi
    \else
      % page
      \ifxput@fanfold
        \xput@cropstart=-\xput@overprint
        \xput@cropend=\dimexpr(\xput@null + \xput@leftbleed + 1pt)\relax
        \xput@cropleftside
        \xput@cropstart=\dimexpr(\xput@pagewidth * 2 + \xput@outerbleed - 1pt)\relax
        \xput@cropend=\dimexpr(\xput@pagewidth * 2 + \xput@outerbleed * 2 + \xput@overprint)\relax
        \xput@croprightside
      \else
        \xput@cropstart=-\xput@overprint
        \xput@cropend=\dimexpr(\xput@null + \xput@leftbleed + 1pt)\relax
        \xput@cropleftside
        \xput@cropstart=\dimexpr(\xput@pagewidth + \xput@outerbleed + \xput@innerbleed - \xput@rightbleed - 1pt)\relax
        \xput@cropend=\dimexpr(\xput@pagewidth + \xput@outerbleed + \xput@innerbleed + \xput@overprint)\relax
        \xput@croprightside
      \fi
    \fi
  \fi
}
\pgfkeys{
  /graphic/.is family,
  /graphic,
  file/.store in=\xput@graphicoptionfile,
  scale/.store in=\xput@graphicoptionscale,
  vpos/.store in=\xput@graphicoptionvpos,
  hpos/.store in=\xput@graphicoptionhpos,
  unsharp/.store in=\xput@graphicoptionunsharp,
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
\def\xput@checkvisibility{
  \xput@isvisibletrue

  \ifxput@frontcover
  \else
    \ifxput@fanfold
    \else
      \ifxput@isdoublepage
        \ifxput@leftpage
          \xput@cropstart=\dimexpr(\xput@pagewidth + \xput@outerbleed - \bindingoffset - 1pt)\relax
          \xput@cropend=\dimexpr(\xput@pagewidth + \xput@outerbleed + \xput@innerbleed)\relax
          \ifdim\xput@x>\xput@cropstart
            \xput@isvisiblefalse
          \fi
        \else
          \xput@cropstart=\dimexpr(\xput@null)\relax
          \xput@cropend=\dimexpr(\xput@null + \xput@leftbleed + \bindingoffset + 1pt)\relax
          \ifdim\xput@xx<\xput@cropend
            \xput@isvisiblefalse
          \fi
        \fi
      \fi
    \fi
  \fi
}
\def\xput@snapoptimizedgraphic{
  \ifdim\xput@snapleft>\xput@null
    \width=\dimexpr\width+\xput@snapleft\relax
  \fi
  \ifdim\xput@snapright>\xput@null
    \width=\dimexpr\width+\xput@snapright\relax
  \fi
  \ifdim\xput@snaptop>\xput@null
    \height=\dimexpr\height+\xput@snaptop\relax
  \fi
  \ifdim\xput@snapbottom>\xput@null
    \height=\dimexpr\height+\xput@snapbottom\relax
  \fi
}
\def\xput@snapgraphic{
  \pgfmathqparse{(\xput@originalgraphicheight-\xput@croptop-\xput@cropbottom)/\height}
  \edef\xput@scale{\pgfmathresult}
  \pgfmathqparse{\height/(\xput@originalgraphicheight-\xput@croptop-\xput@cropbottom)}
  \edef\xput@scalerez{\pgfmathresult}

  % snap
  \ifdim\xput@snapleft>\xput@null
    \ifdim\xput@cropleft>\xput@null
      \ifdim\xput@scale\xput@snapleft>\xput@cropleft
        \xput@snapbleedleft=\xput@cropleft
        \xput@snapleft=\dimexpr\xput@snapleft-\xput@scalerez\xput@cropleft\relax
        \width=\dimexpr\width+\xput@scalerez\xput@cropleft\relax
        \xput@cropleft=\xput@null
      \else
        \xput@snapbleedleft=\dimexpr\xput@scale\xput@snapleft\relax
        \xput@cropleft=\dimexpr\xput@cropleft-\xput@scale\xput@snapleft\relax
        \width=\dimexpr\width+\xput@snapleft\relax
        \xput@snapleft=\xput@null
      \fi
    \fi
  \fi
  \ifdim\xput@snapright>\xput@null
    \ifdim\xput@cropright>\xput@null
      \ifdim\xput@scale\xput@snapright>\xput@cropright
        \xput@snapbleedright=\xput@cropright
        \xput@snapright=\dimexpr\xput@snapright-\xput@scalerez\xput@cropright\relax
        \width=\dimexpr\width+\xput@scalerez\xput@cropright\relax
        \xput@cropright=\xput@null
      \else
        \xput@snapbleedright=\dimexpr\xput@scale\xput@snapright\relax
        \xput@cropright=\dimexpr\xput@cropright-\xput@scale\xput@snapright\relax
        \width=\dimexpr\width+\xput@snapright\relax
        \xput@snapright=\xput@null
      \fi
    \fi
  \fi
  \ifdim\xput@snaptop>\xput@null
    \ifdim\xput@croptop>\xput@null
      \ifdim\xput@scale\xput@snaptop>\xput@croptop
        \xput@snapbleedtop=\xput@croptop
        \xput@snaptop=\dimexpr\xput@snaptop-\xput@scalerez\xput@croptop\relax
        \height=\dimexpr\height+\xput@scalerez\xput@croptop\relax
        \xput@croptop=\xput@null
      \else
        \xput@snapbleedtop=\dimexpr\xput@scale\xput@snaptop\relax
        \xput@croptop=\dimexpr\xput@croptop-\xput@scale\xput@snaptop\relax
        \height=\dimexpr\height+\xput@snaptop\relax
        \xput@snaptop=\xput@null
      \fi
    \fi
  \fi
  \ifdim\xput@snapbottom>\xput@null
    \ifdim\xput@cropbottom>\xput@null
      \ifdim\xput@scale\xput@snapbottom>\xput@cropbottom
        \xput@snapbleedbottom=\xput@cropbottom
        \xput@snapbottom=\dimexpr\xput@snapbottom-\xput@scalerez\xput@cropbottom\relax
        \height=\dimexpr\height+\xput@scalerez\xput@cropbottom\relax
        \xput@cropbottom=\xput@null
      \else
        \xput@snapbleedbottom=\dimexpr\xput@scale\xput@snapbottom\relax
        \xput@cropbottom=\dimexpr\xput@cropbottom-\xput@scale\xput@snapbottom\relax
        \height=\dimexpr\height+\xput@snapbottom\relax
        \xput@snapbottom=\xput@null
      \fi
    \fi
  \fi

  % move
  \ifdim\xput@snapbottom=\xput@null
    \ifdim\xput@snaptop=\xput@null
      \ifdim\xput@snapright>\xput@null
        \ifdim\xput@cropleft>\xput@null
          \ifdim\xput@scale\xput@snapright>\xput@cropleft
            \xput@snapright=\dimexpr\xput@snapright-\xput@scalerez\xput@cropleft\relax
            \width=\dimexpr\width+\xput@scalerez\xput@cropleft\relax
            \xput@cropleft=\xput@null
          \else
            \xput@cropleft=\dimexpr\xput@cropleft-\xput@scale\xput@snapright\relax
            \width=\dimexpr\width+\xput@snapright\relax
            \xput@snapright=\xput@null
          \fi
        \fi
      \fi
      \ifdim\xput@snapleft>\xput@null
        \ifdim\xput@cropright>\xput@null
          \ifdim\xput@scale\xput@snapleft>\xput@cropright
            \xput@snapleft=\dimexpr\xput@snapleft-\xput@scalerez\xput@cropright\relax
            \width=\dimexpr\width+\xput@scalerez\xput@cropright\relax
            \xput@cropright=\xput@null
          \else
            \xput@cropright=\dimexpr\xput@cropright-\xput@scale\xput@snapleft\relax
            \width=\dimexpr\width+\xput@snapleft\relax
            \xput@snapleft=\xput@null
          \fi
        \fi
      \fi
    \fi
  \fi
  \ifdim\xput@snapleft=\xput@null
    \ifdim\xput@snapright=\xput@null
      \ifdim\xput@snaptop>\xput@null
        \ifdim\xput@cropbottom>\xput@null
          \ifdim\xput@scale\xput@snaptop>\xput@cropbottom
            \xput@snaptop=\dimexpr\xput@snaptop-\xput@scalerez\xput@cropbottom\relax
            \height=\dimexpr\height+\xput@scalerez\xput@cropbottom\relax
            \xput@cropbottom=\xput@null
          \else
            \xput@cropbottom=\dimexpr\xput@cropbottom-\xput@scale\xput@snaptop\relax
            \height=\dimexpr\height+\xput@snaptop\relax
            \xput@snaptop=\xput@null
          \fi
        \fi
      \fi
      \ifdim\xput@snapbottom>\xput@null
        \ifdim\xput@croptop>\xput@null
          \ifdim\xput@scale\xput@snapbottom>\xput@croptop
            \xput@snapbottom=\dimexpr\xput@snapbottom-\xput@scalerez\xput@croptop\relax
            \height=\dimexpr\height+\xput@scalerez\xput@croptop\relax
            \xput@croptop=\xput@null
          \else
            \xput@croptop=\dimexpr\xput@croptop-\xput@scale\xput@snapbottom\relax
            \height=\dimexpr\height+\xput@snapbottom\relax
            \xput@snapbottom=\xput@null
          \fi
        \fi
      \fi
    \fi
  \fi
}
\newdimen\xput@snapcropoffset
\newdimen\xput@snapbleedleft\newdimen\xput@snapbleedright
\newdimen\xput@snapbleedtop\newdimen\xput@snapbleedbottom
\def\xput@hscalegraphic{
  \pgfmathqparse{\width/(\width+\xput@snapleft+\xput@snapright)}
  \edef\xput@snapscale{\pgfmathresult}
  \xput@snapcroptmp=\dimexpr\xput@originalgraphicheight-\xput@cropbottom-\xput@croptop-\xput@snapscale\xput@originalgraphicheight+\xput@snapscale\xput@cropbottom+\xput@snapscale\xput@croptop\relax
  \xput@snapcropoffset=\dimexpr\xput@snapbleedbottom-\xput@snapscale\xput@snapbleedbottom-\xput@snapbleedtop+\xput@snapscale\xput@snapbleedtop\relax
  \xput@cropbottom=\dimexpr\xput@cropbottom+0.5\xput@snapcroptmp+0.5\xput@snapcropoffset\relax
  \xput@croptop=\dimexpr\xput@croptop+0.5\xput@snapcroptmp-0.5\xput@snapcropoffset\relax

  \width=\dimexpr\width+\xput@snapleft+\xput@snapright\relax
  \xput@snapright=\xput@null
  \xput@snapleft=\xput@null
}
\def\xput@vscalegraphic{
  \pgfmathqparse{\height/(\height+\xput@snaptop+\xput@snapbottom)}
  \edef\xput@snapscale{\pgfmathresult}
  \xput@snapcroptmp=\dimexpr\xput@originalgraphicwidth-\xput@cropleft-\xput@cropright-\xput@snapscale\xput@originalgraphicwidth+\xput@snapscale\xput@cropleft+\xput@snapscale\xput@cropright\relax
  \xput@snapcropoffset=\dimexpr\xput@snapbleedleft-\xput@snapscale\xput@snapbleedleft-\xput@snapbleedright+\xput@snapscale\xput@snapbleedright\relax
  \xput@cropleft=\dimexpr\xput@cropleft+0.5\xput@snapcroptmp+0.5\xput@snapcropoffset\relax
  \xput@cropright=\dimexpr\xput@cropright+0.5\xput@snapcroptmp-0.5\xput@snapcropoffset\relax

  \height=\dimexpr\height+\xput@snaptop+\xput@snapbottom\relax
  \xput@snaptop=\xput@null
  \xput@snapbottom=\xput@null
}
\def\xput@getbase#1{\edef\Gin@base{\filename@area\filename@base}\edef\Gin@ext{#1}}
\let\xput@getbaseorginal\Gin@getbase
\def\xput@disablegraphicsfilecheck{
  \let\Gin@getbase\xput@getbase
}
\def\xput@enablegraphicsfilecheck{
  \let\Gin@getbase\xput@getbaseorginal
}
\let\xput@setfileorginal\Gin@setfile
\def\xput@setfile#1#2#3{
  \global\edef\xput@currfilebase{\Gin@base}
  \global\edef\xput@currfileext{\Gin@ext}
  \global\@onelevel@sanitize\xput@currfileext
}
\edef\xput@extjpeg{.jpeg}\@onelevel@sanitize\xput@extjpeg
\edef\xput@extJPEG{.JPEG}\@onelevel@sanitize\xput@extJPEG
\edef\xput@extjpg{.jpg}\@onelevel@sanitize\xput@extjpg
\edef\xput@extJPG{.JPG}\@onelevel@sanitize\xput@extJPG
\edef\xput@extpng{.png}\@onelevel@sanitize\xput@extpng
\edef\xput@extPNG{.PNG}\@onelevel@sanitize\xput@extPNG
\def\isoptimizable#1#2{
  \ifx#1\xput@extjpg
    \def\xput@optimizedext{.jpg}#2
  \else
    \ifx#1\xput@extJPG
      \def\xput@optimizedext{.jpg}#2
    \else
      \ifx#1\xput@extjpeg
        \def\xput@optimizedext{.jpg}#2
      \else
        \ifx#1\xput@extJPEG
          \def\xput@optimizedext{.jpg}#2
        \else
          \ifx#1\xput@extpng
            \def\xput@optimizedext{.png}#2
          \else
            \ifx#1\xput@extPNG
              \def\xput@optimizedext{.png}#2
            \fi
          \fi
        \fi
      \fi
    \fi
  \fi
}
\def\newgraphic#1#2{
  \expandafter\newcommand\csname xput@graphic@#1\endcsname[2][0]{%
    \ifnum##1=0
      \pgfkeys{pagegraphic,file={#1},scale=1,vpos=0.5,hpos=0.5,unsharp=\xput@unsharp,#2,##2}
    \else
      \ifnum##1=1
        \pgfkeys{backcoverpagegraphic,file={#1},scale=1,vpos=0.5,hpos=0.5,unsharp=\xput@unsharp,#2}
      \else
        \pgfkeys{graphic,file={#1},scale=1,vpos=0.5,hpos=0.5,unsharp=\xput@unsharp,#2,##2}
      \fi
    \fi
  }%
}
\newcommand\xput@putgraphic[6][]{
  \xput@x=\posx{1}{#2}{1}{#3}
  \xput@yy=\posy{1}{#2}
  \xput@xx=\posx{-1}{#4}{-1}{#5}
  \xput@y=\posy{-1}{#4}

  \xput@checkvisibility

  \ifxput@isvisible
    \xput@cropleft=\xput@null
    \xput@cropbottom=\xput@null
    \xput@cropright=\xput@null
    \xput@croptop=\xput@null

    \width=\dimexpr(\xput@xx - \xput@x)\relax
    \height=\dimexpr(\xput@yy - \xput@y)\relax

    % safezone horizontal
    \xput@snapsafezonehorizontal

    % safezone vertical
    \xput@snapsafezonevertical

    \xput@snapbleedleft=\xput@null
    \xput@snapbleedright=\xput@null
    \xput@snapbleedtop=\xput@null
    \xput@snapbleedbottom=\xput@null

    \begingroup
    \xdef\xput@filename{#6-\xput@density-\xput@graphicoptionscale-\xput@graphicoptionhpos-\xput@graphicoptionvpos-\the\numexpr\xput@snaptop\relax-\the\numexpr\xput@snapright\relax-\the\numexpr\xput@snapbottom\relax-\the\numexpr\xput@snapleft\relax-\the\numexpr\width\relax-\the\numexpr\height\relax-\xput@downsamplethreshold-\xput@graphicoptionunsharp-\xput@quality}
    \ifxput@optimize
      \IfFileExists{./cache/\xput@filename/g.jpg}{
        \def\xput@nextincludegraphic{\includegraphics[width=\width]{cache/\xput@filename/g.jpg}}
      }{
        \IfFileExists{./cache/\xput@filename/g.png}{
          \def\xput@nextincludegraphic{\includegraphics[width=\width]{cache/\xput@filename/g.png}}
        }{
          \xput@calculatecroptrue
        }
      }

      \ifxput@preflight
        \xput@calculatecroptrue
      \fi
    \else
      \xput@calculatecroptrue
    \fi

    \ifxput@calculatecrop
      \global\edef\xput@currfilebase{}
      \global\edef\xput@currfileext{}
      \let\Gin@setfile\xput@setfile
      \Ginclude@graphics#6
      \let\Gin@setfile\xput@setfileorginal
      \ifx\xput@currfileext\xput@emptystring
        \xput@calculatecropfalse
        \def\xput@nextincludegraphic{}
      \fi
    \fi

    \xput@disablegraphicsfilecheck
    \ifxput@calculatecrop
      % graphic crop
      \settowidth{\xput@originalgraphicwidth}{\includegraphics{\xput@currfilebase\xput@currfileext}}
      \settoheight{\xput@originalgraphicheight}{\includegraphics{\xput@currfilebase\xput@currfileext}}
      \pgfmathqparse{1pt-\xput@graphicoptionvpos pt}
      \edef\xput@graphicoptionvpos{\pgfmathresult}
      \pgfmathqparse{\xput@originalgraphicwidth/\xput@originalgraphicheight}
      \edef\xput@graphicratio{\pgfmathresult}
      \pgfmathqparse{\width/\height}
      \edef\xput@vpratio{\pgfmathresult}
      \pgfmathqparse{\xput@graphicratio pt>\xput@vpratio pt}
      \ifnum\pgfmathresult=1
        \xput@cropx=\dimexpr(\numexpr(\xput@originalgraphicwidth - \width * \xput@originalgraphicheight / \height)\relax sp)\relax
        \xput@cropy=\xput@null
      \else
        \xput@cropy=\dimexpr(\numexpr(\xput@originalgraphicheight - \height * \xput@originalgraphicwidth / \width)\relax sp)\relax
        \xput@cropx=\xput@null
      \fi
      \xput@viewportwidth=\dimexpr\xput@originalgraphicwidth-\xput@cropx\relax
      \xput@viewportheight=\dimexpr\xput@originalgraphicheight-\xput@cropy\relax
      \pgfmathqparse{1pt/\xput@graphicoptionscale pt}
      \edef\xput@reciprocalscale{\pgfmathresult}
      \xput@cropx=\dimexpr\xput@cropx + \xput@viewportwidth - \xput@reciprocalscale\xput@viewportwidth\relax
      \xput@cropy=\dimexpr\xput@cropy + \xput@viewportheight - \xput@reciprocalscale\xput@viewportheight\relax
      \ifdim\xput@cropx>\xput@null
        \xput@cropleft=\dimexpr(\xput@graphicoptionhpos\xput@cropx)\relax
        \ifdim\xput@cropleft<\xput@null
          \xput@cropleft=\xput@null
        \fi
        \ifdim\xput@cropleft>\xput@cropx
          \xput@cropleft=\xput@cropx
        \fi
        \xput@cropright=\dimexpr(\xput@cropx - \xput@cropleft)\relax
      \fi
      \ifdim\xput@cropy>\xput@null
        \xput@cropbottom=\dimexpr(\xput@graphicoptionvpos\xput@cropy)\relax
        \ifdim\xput@cropbottom<\xput@null
          \xput@cropbottom=\xput@null
        \fi
        \ifdim\xput@cropbottom>\xput@cropy
          \xput@cropbottom=\xput@cropy
        \fi
        \xput@croptop=\dimexpr(\xput@cropy - \xput@cropbottom)\relax
      \fi

      \xput@snapgraphic
      \ifdim\dimexpr\xput@snapleft+\xput@snapright\relax=\xput@null
        \ifdim\dimexpr\xput@snaptop+\xput@snapbottom\relax>\xput@null
          \xput@vscalegraphic
        \fi
      \else
        \ifdim\dimexpr\xput@snaptop+\xput@snapbottom\relax=\xput@null
          \ifdim\dimexpr\xput@snapleft+\xput@snapright\relax>\xput@null
            \xput@hscalegraphic
          \fi
        \else
          \ifdim\dimexpr\width/(\xput@snapleft + \xput@snapright)\relax<\dimexpr\height/(\xput@snaptop + \xput@snapbottom)\relax
            \xput@hscalegraphic

            \xput@snapgraphic
          \else
            \xput@vscalegraphic

            \xput@snapgraphic
          \fi
        \fi
      \fi

      \ifdim\xput@snapleft>\xput@null
        \xput@x=\dimexpr\xput@x+\xput@snapleft\relax
      \fi
      \ifdim\xput@snapbottom>\xput@null
        \xput@y=\dimexpr\xput@y+\xput@snapbottom\relax
      \fi
    \else
      \xput@snapoptimizedgraphic
    \fi

    \ifdefined\xput@nextincludegraphic
    \else
      \ifxput@optimize
        \ifxput@isbatchmode
          \isoptimizable{\xput@currfileext}{\xput@addtobatchlist{\xput@currfilebase}{\xput@currfileext}}
          \def\xput@nextincludegraphic{}
        \else
          \isoptimizable{\xput@currfileext}{\xput@optimizegraphic{\xput@currfilebase}{\xput@currfileext}}
          \ifdefined\xput@optimizedext
            \IfFileExists{./cache/\xput@filename/g\xput@optimizedext}{
              \def\xput@nextincludegraphic{\includegraphics[width=\width]{cache/\xput@filename/g\xput@optimizedext}}
            }{
              \ifx\xput@processresult\xput@ok
                \ClassError{Xput}{Unexpected error. File not optimized}{File `cache/#6/g\xput@optimizedext' not found.\MessageBreak Try to delete the `cache' directory.\MessageBreak\MessageBreak\@ehc}
              \fi
              \def\xput@nextincludegraphic{\includegraphics[trim={\xput@cropleft} {\xput@cropbottom} {\xput@cropright} {\xput@croptop},\xput@clip,width=\width]{\xput@currfilebase\xput@currfileext}}
            }
          \else
            \def\xput@nextincludegraphic{\includegraphics[trim={\xput@cropleft} {\xput@cropbottom} {\xput@cropright} {\xput@croptop},\xput@clip,width=\width]{\xput@currfilebase\xput@currfileext}}
          \fi
        \fi
      \else
        \def\xput@nextincludegraphic{\includegraphics[trim={\xput@cropleft} {\xput@cropbottom} {\xput@cropright} {\xput@croptop},\xput@clip,width=\width]{\xput@currfilebase\xput@currfileext}}
      \fi
    \fi

    \ifdim\xput@defaultborderradius>0.5\height
      \def\xput@defaultborderradius{0.5\height}
    \fi
    \ifdim\xput@defaultborderradius>0.5\width
      \def\xput@defaultborderradius{0.5\width}
    \fi

    \xput@frameborderwidth=\dimexpr\xput@defaultborderwidth\relax
    \ifdim\xput@defaultborderradius=0pt
      \xput@frameborderradius=0pt
      \xput@frameshadowradius=0pt
    \else
      \xput@frameborderradius=\dimexpr\xput@defaultborderradius+0.5\xput@frameborderwidth\relax
      \xput@frameshadowradius=\dimexpr\xput@defaultborderradius+\xput@frameborderwidth\relax
    \fi

    % draw shadow
    \ifxput@isbatchmode
    \else
      \def\xput@frameshadowoffsetx{\xput@frameborderwidth}
      \def\xput@frameshadowoffsety{\xput@frameborderwidth}
      \def\xput@frameshadowwidth{\dimexpr\width+10cm+2\xput@frameborderwidth\relax}
      \def\xput@frameshadowheight{\dimexpr\height+10cm+2\xput@frameborderwidth\relax}
      \def\xput@frameshadowframewidth{\dimexpr\width+2\xput@frameborderwidth\relax}
      \def\xput@frameshadowframeheight{\dimexpr\height+2\xput@frameborderwidth\relax}
      \def\xput@frameshadowborder{\dimexpr5cm\relax}
      \xput@drawshadow
    \fi

    % draw graphic and border
    \ifxput@isbatchmode
      \xput@ismaskrequiredfalse
      \def\xput@nextincludegraphic{}
    \else
      \ifxput@isperformancemode
        \ifdim\xput@defaultborderwidth>0pt
          \xput@ismaskrequiredtrue
        \else
          \ifdim\xput@defaultborderradius>0pt
            \xput@ismaskrequiredtrue
          \else
            \xput@ismaskrequiredfalse
          \fi
        \fi
      \else
        \xput@ismaskrequiredtrue
      \fi
    \fi

    \ifxput@ismaskrequired
      \def\xput@clip{}%
    \else
      \def\xput@clip{clip}%
    \fi

    \put(\xput@dimentonumber{\xput@x},\xput@dimentonumber{\xput@y}){%
      \ifxput@ismaskrequired%
        \begin{tikzpicture}%
          \pgflowlevelsynccm%
          \ifdim\xput@defaultborderwidth>0pt
            \draw[draw=\xput@defaultbordercolor,draw opacity=\xput@defaultborderopacity,line width=\xput@frameborderwidth,rounded corners=\xput@frameborderradius] (-0.5\xput@frameborderwidth,-0.5\xput@frameborderwidth) rectangle ++(\width+\xput@frameborderwidth,\height+\xput@frameborderwidth);%
          \fi

          \draw[draw opacity=0,rounded corners=\xput@defaultborderradius,path picture={
            \node at (0.5\width,0.5\height){
              \xput@nextincludegraphic
            };
          }] (0,0) rectangle ++(\width,\height);%
        \end{tikzpicture}%
      \else%
        \xput@nextincludegraphic
      \fi%
    }

    \xput@enablegraphicsfilecheck

    % draw ppi
    \ifxput@preflight
      \ifx\xput@nextincludegraphic\xput@emptystring
      \else
        \isoptimizable{\xput@currfileext}{\xput@getppi{\xput@currfilebase\xput@currfileext}}
        \ifdefined\xput@graphicdensity
          \xput@drawppi{#2}{#3}{#4}{#5}{#6}{\xput@graphicdensity}
        \fi
      \fi
    \fi
    \endgroup
  \fi
}
\newcommand\xput@drawppi[6]{
  \xput@x=\posx{1}{#1}{1}{#2}
  \xput@yy=\posy{1}{#1}
  \xput@xx=\posx{-1}{#3}{-1}{#4}
  \xput@y=\posy{-1}{#3}
  \width=\dimexpr(\xput@xx - \xput@x)\relax
  \height=\dimexpr(\xput@yy - \xput@y)\relax
  \def\xput@ppicolor{green!50!black}
  \def\xput@ppicolortext{white}
  \ifnum#6<300
    \def\xput@ppicolor{yellow}
    \def\xput@ppicolortext{black}
    \ifnum#6<200
      \def\xput@ppicolor{red}
      \def\xput@ppicolortext{white}
      \xput@errmsg@lowdensity{1}{#5}{#6}
    \else
      \xput@errmsg@lowdensity{0}{#5}{#6}
    \fi
  \fi
  \put(\xput@dimentonumber{\xput@x},\xput@dimentonumber{\xput@y}){%
    \begin{tikzpicture}%
      \pgflowlevelsynccm%
      \node[fill=\xput@ppicolor,fill opacity=0.9,line width=0pt,anchor=north east] at (\width,\height){
        \color{\xput@ppicolortext}\textbf{#6ppi}
      };
    \end{tikzpicture}%
  }
}

% pagegraphic
\def\xput@pagegraphic{}
\pgfkeys{
  /pagegraphic/.is family,
  /pagegraphic,
  file/.store in=\xput@pagegraphic,
  scale/.store in=\xput@pagegraphicoptionscale,
  vpos/.store in=\xput@pagegraphicoptionvpos,
  hpos/.store in=\xput@pagegraphicoptionhpos,
  unsharp/.store in=\xput@pagegraphicoptionunsharp,
}
\pgfkeys{
  /backcoverpagegraphic/.is family,
  /backcoverpagegraphic,
  file/.store in=\xput@backcoveroptionpagegraphicfile,
  scale/.store in=\xput@backcoveroptionpagegraphicscale,
  vpos/.store in=\xput@backcoveroptionpagegraphicvpos,
  hpos/.store in=\xput@backcoveroptionpagegraphichpos,
  unsharp/.store in=\xput@backcoveroptionpagegraphicunsharp,
}
\def\xput@putpagegraphic{
  \begingroup
    \margin=\xput@null
    \topmargin=\xput@null
    \bottommargin=\xput@null
    \innermargin=\xput@null
    \outermargin=\xput@null
    \setgrid{{{1}}}
    \pgfkeys{graphic,scale=\xput@pagegraphicoptionscale,hpos=\xput@pagegraphicoptionhpos,vpos=\xput@pagegraphicoptionvpos,unsharp=\xput@pagegraphicoptionunsharp,border width=0pt,border radius=0pt,shadow size=0}
    \xput@putgraphic{0}{0}{1}{1}{\xput@pagegraphic}
  \endgroup
}
\newcommand\setpagegraphic[2][]{
  \ifcsname xput@graphic@#2\endcsname%
    \csname xput@graphic@#2\endcsname{#1}
  \else%
    \pgfkeys{pagegraphic,file={#2},scale=1,vpos=0.5,hpos=0.5,unsharp=\xput@unsharp,#1}
  \fi
}
\def\nopagegraphic{\setpagegraphic{}}

% text
\newdimen\xput@textboxheight
\newdimen\xput@textboxwidth
\newdimen\xput@leftwidth
\newdimen\xput@rightwidth
\newcommand\xput@checkside[1]{
  \ifxput@fanfold
    \ifxput@isdoublepage
      \xput@leftwidth=\dimexpr(\xput@pagewidth + \xput@outerbleed - \xput@x)\relax
      \xput@rightwidth=\dimexpr(\xput@xx - \xput@pagewidth - \xput@outerbleed)\relax
      \ifdim\xput@rightwidth>\xput@leftwidth
        \ifnum#1=1
          \xput@leftpagefalse
          \xput@rightpagetrue
        \else
          \xput@leftpagetrue
          \xput@rightpagefalse
        \fi
        \addtocounter{page}{#1}
      \fi
    \fi
  \fi
}
\def\xput@textoptionbottom{bottom}
\def\xput@textoptioncenter{center}
\newif\ifxput@text@option@top
\newif\ifxput@text@option@center
\newif\ifxput@text@option@bottom
\newif\ifxput@text@option@parbox
\newif\ifxput@text@option@breakable
\let\originaltcbset\tcbset
\pgfkeys{
  /inittext/.is family,
  /inittext,
  color/.code={\color{#1}},
  coltext/.forward to=/inittext/color,
  boxrule/.code={\def\xput@defaultborderwidth{#1}\def\xput@text@option@leftrule{#1}\def\xput@text@option@rightrule{#1}\def\xput@text@option@toprule{#1}\def\xput@text@option@bottomrule{#1}},
  toprule/.code={\def\xput@text@option@toprule{#1}},
  rightrule/.code={\def\xput@text@option@rightrule{#1}},
  bottomrule/.code={\def\xput@text@option@bottomrule{#1}},
  leftrule/.code={\def\xput@text@option@leftrule{#1}},
  height/.code={\def\xput@text@option@height{#1}},
  arc/.code={\ifdim\xput@null=\dimexpr#1\relax\originaltcbset{outer arc=#1}\else\originaltcbset{auto outer arc}\fi\def\xput@defaultborderradius{#1}},
  colframe/.store in=\xput@defaultbordercolor,
  opacityframe/.store in=\xput@defaultborderopacity,
  breakable/.is if=xput@text@option@breakable,
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
  \ifcsname xput@border@#1\endcsname
    \csname xput@border@#1\endcsname[1]{}
  \else
    \pgfkeys{textborder,opacity=1,width=0pt,color=black,radius=0pt}
    \xput@errmsg@undefined{border}{#1}
  \fi
}
\pgfkeys{
  /text/.is family,
  /text,
  name/.store in=\xput@text@option@name,
  color/.code={\originaltcbset{coltext=#1}\def\xput@text@option@color{#1}},
  opacity/.code={\originaltcbset{opacitytext=#1}},
  top/.code={\originaltcbset{valign=top}\xput@text@option@toptrue},
  center/.code={\originaltcbset{valign=center}\xput@text@option@centertrue},
  bottom/.code={\originaltcbset{valign=bottom}\xput@text@option@bottomtrue},
  boxrule/.code={\originaltcbset{boxrule=#1}\def\xput@defaultborderwidth{#1}\def\xput@text@option@leftrule{#1}\def\xput@text@option@rightrule{#1}\def\xput@text@option@toprule{#1}\def\xput@text@option@bottomrule{#1}},
  toprule/.code={\originaltcbset{toprule=#1}\def\xput@text@option@toprule{#1}},
  rightrule/.code={\originaltcbset{rightrule=#1}\def\xput@text@option@rightrule{#1}},
  bottomrule/.code={\originaltcbset{bottomrule=#1}\def\xput@text@option@bottomrule{#1}},
  leftrule/.code={\originaltcbset{leftrule=#1}\def\xput@text@option@leftrule{#1}},
  height/.code={\originaltcbset{height=#1}\def\xput@text@option@height{#1}},
  parbox/.is if=xput@text@option@parbox,
  breakable/.is if=xput@text@option@breakable,
  border radius/.code={\originaltcbset{arc=#1}\ifdim\xput@null=\dimexpr#1\relax\originaltcbset{outer arc=#1}\else\originaltcbset{auto outer arc}\fi\def\xput@defaultborderradius{#1}},
  arc/.forward to=/text/border radius,
  border width/.forward to=/text/boxrule,
  border color/.code={\originaltcbset{colframe=#1}\def\xput@defaultbordercolor{#1}},
  border opacity/.code={\originaltcbset{opacityframe=#1}\def\xput@defaultborderopacity{#1}},
  shadow/.forward to=/defaultshadow/name,
  shadow size/.forward to=/defaultshadow/size,
  shadow color/.forward to=/defaultshadow/color,
  shadow opacity/.forward to=/defaultshadow/opacity,
  shadow xshift/.forward to=/defaultshadow/xshift,
  shadow yshift/.forward to=/defaultshadow/yshift,
  .unknown/.code={\originaltcbset{\pgfkeyscurrentname=#1}}
}
\newdimen\xput@tcbheight
\newcommand\xput@puttext[5]{
  \ifxput@isbatchmode
  \else
    \xput@x=\posx{1}{#1}{1}{#2}
    \xput@xx=\posx{-1}{#3}{-1}{#4}
    \xput@y=\posy{-1}{#3}
    \xput@yy=\posy{1}{#1}

    \xput@xx=\dimexpr\xput@xx+\xput@text@option@rightrule\relax
    \xput@x=\dimexpr\xput@x-\xput@text@option@leftrule\relax
    \xput@yy=\dimexpr\xput@yy+\xput@text@option@toprule\relax
    \xput@y=\dimexpr\xput@y-\xput@text@option@bottomrule\relax

    \width=\dimexpr(\xput@xx - \xput@x)\relax
    \height=\dimexpr(\xput@yy - \xput@y)\relax
    \xput@textboxwidth=\dimexpr(\xput@xx - \xput@x)\relax
    \xput@textboxheight=\dimexpr(\xput@yy - \xput@y)\relax

    \ifdefined\xput@text@option@height
      \ifdim\xput@text@option@height=\height
      \else
        \xput@tcbheight=\dimexpr\xput@text@option@height\ifdefined\xput@text@option@toprule+\xput@text@option@toprule\else\ifdefined\xput@defaultborderwidth+\xput@defaultborderwidth\fi\fi\ifdefined\xput@text@option@bottomrule+\xput@text@option@bottomrule\else\ifdefined\xput@defaultborderwidth+\xput@defaultborderwidth\fi\fi\relax
        \originaltcbset{height=\xput@tcbheight}
      \fi
    \else
    \fi

    \xput@checkvisibility
    \ifxput@isvisible
      \xput@checkside{1}
      \ifxput@text@option@parbox
        \ifdim\xput@textboxheight<\xput@null
          \xput@yy=\dimexpr\xput@yy-\xput@textboxheight\relax
          \xput@textboxheight=\dimexpr-1\xput@textboxheight\relax
        \fi
        \put(\xput@dimentonumber{\xput@x},\xput@dimentonumber{\xput@yy}){%
          \parbox[t][\xput@textboxheight][\ifxput@text@option@center c\else\ifxput@text@option@bottom b\else t\fi\fi]{\xput@textboxwidth}{\vskip \xput@null
            \color{\xput@text@option@color}%
            #5%
          }
        }
      \else
        \ifdim\xput@text@option@bottomrule<\xput@text@option@toprule
          \def\xput@text@minvborderwidth{\xput@text@option@bottomrule}
          \def\xput@text@maxvborderwidth{\xput@text@option@toprule}
        \else
          \def\xput@text@minvborderwidth{\xput@text@option@toprule}
          \def\xput@text@maxvborderwidth{\xput@text@option@bottomrule}
        \fi
        \ifdim\xput@text@option@leftrule<\xput@text@option@rightrule
          \def\xput@text@minhborderwidth{\xput@text@option@leftrule}
          \def\xput@text@maxhborderwidth{\xput@text@option@rightrule}
        \else
          \def\xput@text@minhborderwidth{\xput@text@option@rightrule}
          \def\xput@text@maxhborderwidth{\xput@text@option@leftrule}
        \fi
        \ifdim\xput@text@minvborderwidth<\xput@text@minhborderwidth
          \def\xput@text@minborderwidth{\xput@text@minvborderwidth}
          \def\xput@text@maxborderwidth{\xput@text@maxhborderwidth}
        \else
          \def\xput@text@minborderwidth{\xput@text@minhborderwidth}
          \def\xput@text@maxborderwidth{\xput@text@maxvborderwidth}
        \fi
        \ifdim\xput@text@maxborderwidth=\xput@null
          \originaltcbset{opacityframe=0}
        \fi

        \ifxput@text@option@breakable
          \expandafter\xdef\csname xput@textarray@\xput@text@option@name @offsetx\endcsname{\xput@text@option@leftrule}
          \expandafter\xdef\csname xput@textarray@\xput@text@option@name @offsety\endcsname{\xput@text@option@bottomrule}
        \else
          \def\xput@text@option@name{xput@unbreakable}
        \fi
        \ifcsname xput@textarray@\xput@text@option@name @index\endcsname
          \global\expandafter\csname xput@textarray@\xput@text@option@name @index\endcsname 0 \relax%
          \boxarrayclear[\xput@text@option@name]
        \else
          \global\expandafter\newcount\csname xput@textarray@\xput@text@option@name @index\endcsname%
          \newboxarray{\xput@text@option@name}
        \fi
        \put(0,0){
          \ifxput@text@option@breakable%
            \begin{tcolorbox}[
              standard jigsaw,
              width=\width,
              enforce breakable,
              break at=\height,
              height fixed for=all,
              reset box array=\xput@text@option@name,
              store to box array=\xput@text@option@name,
            ]%
              #5
            \end{tcolorbox}%
          \else%
            \begin{tcolorbox}[
              standard jigsaw,
              width=\width,
              reset box array=\xput@text@option@name,
              store to box array=\xput@text@option@name,
            ]%
              #5
            \end{tcolorbox}%
          \fi%
        }
        \global\expandafter\advance\csname xput@textarray@\xput@text@option@name @index\endcsname by 1%

        \boxarraygetheight[\xput@text@option@name]{\xput@text@height}{1}
        \ifxput@text@option@bottom
          \xput@yy=\dimexpr\xput@yy-(\xput@textboxheight-\xput@text@height)\relax
        \else
          \ifxput@text@option@center
            \xput@yy=\dimexpr\xput@yy-(\xput@textboxheight-\xput@text@height)/2\relax
          \fi
        \fi
        \xput@textboxheight=\xput@text@height
        \xput@y=\dimexpr\xput@yy-\xput@textboxheight\relax

        % draw shadow
        \xput@ifshadow{
          \ifdefined\xput@defaultborderradius
            \ifdim\xput@defaultborderradius=0pt
              \xput@frameshadowradius=0pt
            \else
              \xput@frameshadowradius=\dimexpr\xput@defaultborderradius+\xput@text@minborderwidth\relax
            \fi
          \else
            \xput@frameshadowradius=0pt
          \fi

          \def\xput@frameshadowoffsetx{0pt}
          \def\xput@frameshadowoffsety{0pt}

          \def\xput@frameshadowwidth{\dimexpr\width+10cm\relax}
          \def\xput@frameshadowheight{\dimexpr\xput@textboxheight+10cm\relax}
          \def\xput@frameshadowframewidth{\width}
          \def\xput@frameshadowframeheight{\xput@textboxheight}
          \def\xput@frameshadowborder{\dimexpr5cm\relax}
          \ifxput@text@option@breakable
            \expandafter\xdef\csname xput@textarray@\xput@text@option@name @shadowsize\endcsname{\xput@defaultshadowsize}
            \expandafter\xdef\csname xput@textarray@\xput@text@option@name @shadowcolor\endcsname{\xput@defaultshadowcolor}
            \expandafter\xdef\csname xput@textarray@\xput@text@option@name @shadowopacity\endcsname{\xput@defaultshadowopacity}
            \expandafter\xdef\csname xput@textarray@\xput@text@option@name @shadowxshift\endcsname{\xput@defaultshadowxshift}
            \expandafter\xdef\csname xput@textarray@\xput@text@option@name @shadowyshift\endcsname{\xput@defaultshadowyshift}
            \expandafter\xdef\csname xput@textarray@\xput@text@option@name @frameshadowwidth\endcsname{\the\xput@frameshadowwidth}
            \expandafter\xdef\csname xput@textarray@\xput@text@option@name @frameshadowheight\endcsname{\the\xput@frameshadowheight}
            \expandafter\xdef\csname xput@textarray@\xput@text@option@name @frameshadowframewidth\endcsname{\the\xput@frameshadowframewidth}
            \expandafter\xdef\csname xput@textarray@\xput@text@option@name @frameshadowframeheight\endcsname{\the\xput@frameshadowframeheight}
            \expandafter\xdef\csname xput@textarray@\xput@text@option@name @frameshadowborder\endcsname{\the\xput@frameshadowborder}
            \expandafter\xdef\csname xput@textarray@\xput@text@option@name @frameshadowradius\endcsname{\the\xput@frameshadowradius}
          \fi
          \xput@drawshadow
        }

        \put(\xput@dimentonumber{\xput@x},\xput@dimentonumber{\xput@y}){%
          \consumeboxarray[\xput@text@option@name]{\the\csname xput@textarray@\xput@text@option@name @index\endcsname}%
        }
      \fi
      \xput@checkside{-1}
    \fi
  \fi
}
\newcommand\xput@putusetext[5][default]{
  \ifxput@isbatchmode
  \else
    \xput@x=\posx{1}{#2}{1}{#3}
    \xput@xx=\posx{-1}{#4}{-1}{#5}
    \xput@y=\posy{-1}{#4}
    \xput@yy=\posy{1}{#2}
    \width=\dimexpr(\xput@xx - \xput@x)\relax
    \height=\dimexpr(\xput@yy - \xput@y)\relax
    \xput@textboxwidth=\dimexpr(\xput@xx - \xput@x)\relax
    \xput@textboxheight=\dimexpr(\xput@yy - \xput@y)\relax

    \xput@checkvisibility
    \ifxput@isvisible
      \ifcsname xput@textarray@#1@index\endcsname
        \global\expandafter\advance\csname xput@textarray@#1@index\endcsname by 1%

        \xput@y=\dimexpr\xput@yy-\xput@textboxheight\relax

        \ifcsname xput@textarray@#1@shadowsize\endcsname
          \def\xput@frameshadowoffsetx{\expandafter\csname xput@textarray@#1@offsetx\endcsname}
          \def\xput@frameshadowoffsety{\expandafter\csname xput@textarray@#1@offsety\endcsname}

          \def\xput@frameshadowwidth{\dimexpr\expandafter\csname xput@textarray@#1@frameshadowwidth\endcsname\relax}
          \def\xput@frameshadowheight{\dimexpr\expandafter\csname xput@textarray@#1@frameshadowheight\endcsname\relax}
          \def\xput@frameshadowframewidth{\dimexpr\expandafter\csname xput@textarray@#1@frameshadowframewidth\endcsname\relax}
          \def\xput@frameshadowframeheight{\dimexpr\expandafter\csname xput@textarray@#1@frameshadowframeheight\endcsname\relax}
          \def\xput@frameshadowborder{\dimexpr\expandafter\csname xput@textarray@#1@frameshadowborder\endcsname\relax}
          \def\xput@frameshadowradius{\dimexpr\expandafter\csname xput@textarray@#1@frameshadowradius\endcsname\relax}

          \def\xput@defaultshadowsize{\expandafter\csname xput@textarray@#1@shadowsize\endcsname}
          \def\xput@defaultshadowcolor{\expandafter\csname xput@textarray@#1@shadowcolor\endcsname}
          \def\xput@defaultshadowopacity{\expandafter\csname xput@textarray@#1@shadowopacity\endcsname}
          \def\xput@defaultshadowxshift{\dimexpr\expandafter\csname xput@textarray@#1@shadowxshift\endcsname\relax}
          \def\xput@defaultshadowyshift{\dimexpr\expandafter\csname xput@textarray@#1@shadowyshift\endcsname\relax}

          \xput@drawshadow
        \fi

        \xput@checkside{1}
        \put(\xput@dimentonumber{\xput@x-\expandafter\csname xput@textarray@#1@offsetx\endcsname},\xput@dimentonumber{\xput@y-\expandafter\csname xput@textarray@#1@offsety\endcsname}){%
          \consumeboxarray[#1]{\the\csname xput@textarray@#1@index\endcsname}%
        }
        \xput@checkside{-1}
      \else
        \xput@errmsg@undefined{breakable text}{#1}
      \fi
    \fi
  \fi
}

% xput
\newcommand\xput@putxput[6][0]{
  \xput@x=\posx{1}{#2}{1}{#3}
  \xput@xx=\posx{-1}{#4}{-1}{#5}
  \xput@y=\posy{-1}{#4}
  \xput@yy=\posy{1}{#2}

  \xput@checkvisibility
  \ifxput@isvisible
    \ifnum#1=1
      \xput@snapsafezonehorizontal
      \xput@snapsafezonevertical
    \fi

    \width=\dimexpr(\xput@xx - \xput@x)\relax
    \height=\dimexpr(\xput@yy - \xput@y)\relax

    \put(\xput@dimentonumber{\xput@x},\xput@dimentonumber{\xput@y}){%
      \ifx\xput@pageoptioncolor\xput@emptystring
        \color{\xputoptions@color}%
      \else
        \color{\xput@pageoptioncolor}%
      \fi
      #6
    }
  \fi
}

% tikzgraphic
\newcommand\xput@puttikz[6][0]{
  \ifxput@isbatchmode
  \else
    \xput@putxput[#1]{#2}{#3}{#4}{#5}{%
      \begin{tikzpicture}
        \pgflowlevelsynccm
        #6
      \end{tikzpicture}
    }
  \fi
}

% border
\def\xput@defaultborderwidth{0pt}
\def\xput@defaultborderradius{0pt}
\def\xput@defaultbordercolor{black}
\def\xput@defaultborderopacity{1}
\pgfkeysdef{/defaultborder/name}{
  \ifcsname xput@border@#1\endcsname
    \csname xput@border@#1\endcsname{}
  \else
    \pgfkeys{defaultborder,opacity=1,width=0pt,color=black,radius=0pt}
    \xput@errmsg@undefined{border}{#1}
  \fi
}
\newcommand\newborder[2]{
  \expandafter\newcommand\csname xput@border@#1\endcsname[2][0]{%
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
  radius/.store in=\xput@defaultborderradius,
  width/.store in=\xput@defaultborderwidth,
  color/.store in=\xput@defaultbordercolor,
  opacity/.store in=\xput@defaultborderopacity,
}
\newcommand\setborder[2][]{
  \ifxput@placeholdermode
    \ifnum\xput@contentcounter<\xput@placeholdercounter
      \xput@border{#1}{#2}
    \fi
  \else
    \xput@border{#1}{#2}
  \fi
}
\def\noborder{\setborder{}}
\newcommand\xput@border[2]{
  \pgfkeys{defaultborder,width=0pt,color=black,opacity=1,radius=0pt,#1}
  \ifcsname xput@border@#2\endcsname
    \csname xput@border@#2\endcsname{#1}
  \fi
}

% shadow
\def\xput@defaultshadowsize{0}
\def\xput@defaultshadowopacity{0.4}
\def\xput@defaultshadowcolor{black}
\def\xput@defaultshadowxshift{0pt}
\def\xput@defaultshadowyshift{0pt}
\pgfkeysdef{/defaultshadow/name}{
  \ifcsname xput@shadow@#1\endcsname
    \csname xput@shadow@#1\endcsname{}
  \else
    \pgfkeys{defaultshadow,opacity=0.4,size=0,color=black,xshift=0pt,yshift=0pt}
    \xput@errmsg@undefined{shadow}{#1}
  \fi
}
\newcommand\newshadow[2]{
  \expandafter\newcommand\csname xput@shadow@#1\endcsname[1]{%
    \pgfkeys{defaultshadow,opacity=0.4,size=0,color=black,xshift=0pt,yshift=0pt,#2,##1}
  }%
}
\pgfkeys{
  /defaultshadow/.is family,
  /defaultshadow,
  size/.store in=\xput@defaultshadowsize,
  color/.store in=\xput@defaultshadowcolor,
  opacity/.store in=\xput@defaultshadowopacity,
  xshift/.store in=\xput@defaultshadowxshift,
  yshift/.store in=\xput@defaultshadowyshift,
}
\newcommand\setshadow[2][]{
  \ifxput@placeholdermode
    \ifnum\xput@contentcounter<\xput@placeholdercounter
      \xput@shadow{#1}{#2}
    \fi
  \else
    \xput@shadow{#1}{#2}
  \fi
}
\def\noshadow{\setshadow{}}
\newcommand\xput@shadow[2]{
  \pgfkeys{defaultshadow,size=0pt,color=black,opacity=1,xshift=0pt,yshift=0pt,#1}
  \ifcsname xput@shadow@#2\endcsname
    \csname xput@shadow@#2\endcsname{#1}
  \fi
}
\newcommand\xput@ifshadow[1]{
  \ifdim\dimexpr\xput@defaultshadowsize pt\relax>\xput@null
    #1
  \else
    \ifdim\xput@defaultshadowxshift>\xput@null
      #1
    \else
      \ifdim\xput@defaultshadowyshift>\xput@null
        #1
      \fi
    \fi
  \fi
}
\def\xput@drawshadow{
  \xput@ifshadow{
    \xdef\xput@shadowid{shadow-\xput@defaultshadowsize-\xput@defaultshadowcolor-\xput@defaultshadowopacity-\the\numexpr\xput@frameshadowwidth\relax-\the\numexpr\xput@frameshadowheight\relax-\the\numexpr\xput@frameshadowradius\relax-\the\numexpr\xput@frameshadowborder\relax}
    \IfFileExists{./cache/\xput@shadowid/s.pdf}{
    \put(\xput@dimentonumber{\dimexpr\xput@x-5cm-\xput@frameshadowoffsetx+\xput@defaultshadowxshift\relax},\xput@dimentonumber{\dimexpr\xput@y-5cm-\xput@frameshadowoffsety-\xput@defaultshadowyshift\relax}){%
      \includegraphics[width=\xput@frameshadowwidth]{cache/\xput@shadowid/s.pdf}
    }
    }{
      \xput@makeshadow{\xput@shadowid}
      \IfFileExists{./cache/\xput@shadowid/s.pdf}{
      \put(\xput@dimentonumber{\dimexpr\xput@x-5cm-\xput@frameshadowoffsetx+\xput@defaultshadowxshift\relax},\xput@dimentonumber{\dimexpr\xput@y-5cm-\xput@frameshadowoffsety-\xput@defaultshadowyshift\relax}){%
        \includegraphics[width=\xput@frameshadowwidth]{cache/\xput@shadowid/s.pdf}
      }
      }{
        \ifx\xput@processresult\xput@ok
          \ClassError{Xput}{Unexpected error. Shadow not created}{File `cache/\xput@shadowid/s.pdf' not\MessageBreak found.\MessageBreak\MessageBreak\@ehc}
        \fi
      }
    }
  }
}

% layout helper
\def\xput@gridcolor{green!90!black}
\def\xput@gridopacity{0.8}
\def\xput@gutteropacity{0.2}
\newdimen\xput@gridx
\newdimen\xput@gridxx
\newdimen\xput@gridy
\newdimen\xput@gridyy
\newcommand\xput@putgrid{
  \ifxput@isemptypage
  \else
    \ifxput@grid
      \xput@gridx=\posx{1}{1}{1}{0}
      \xput@gridxx=\posx{-1}{1}{-1}{\xput@get{1C}}
      \xput@gridy=\posy{1}{0}
      \xput@gridyy=\posy{-1}{\xput@rowscount}
      \put(0,0){%
        \begin{tikzpicture}%
          \pgflowlevelsynccm%
          \foreach \rowI in {1,...,\xput@rowscount} {
            \ifnum\rowI<\xput@rowscount
              \ifdim\xput@gutter=\xput@null
                \draw[line cap=rect,line width=0.2mm,draw=\xput@gridcolor,opacity=\xput@gridopacity] ({\xput@gridx+0.05mm},{\posy{0}{\rowI}}) -- ({\xput@gridxx-0.05mm},{\posy{0}{\rowI}});%
              \else
                \draw[line cap=rect,line width=\xput@gutter,draw=\xput@gridcolor,opacity=\xput@gutteropacity] ({\xput@gridx+\xput@gutter/2},{\posy{0}{\rowI}}) -- ({\xput@gridxx-\xput@gutter/2},{\posy{0}{\rowI}});%
              \fi
            \fi
            \ifnum\numexpr\xput@get{\rowI C} - 1\relax>0
              \foreach \cellI in {1,...,\numexpr\xput@get{\rowI C} - 1\relax} {
                \ifdim\xput@gutter=\xput@null
                  \draw[line width=0.2mm,draw=\xput@gridcolor,opacity=\xput@gridopacity] ({\posx{-1}{\rowI}{0}{\cellI}},{\posy{1}{\numexpr\rowI - 1\relax}}) -- ({\posx{-1}{\rowI}{0}{\cellI}},{\posy{-1}{\rowI}});%
                \else
                  \draw[line width=\xput@gutter,draw=\xput@gridcolor,opacity=\xput@gutteropacity] ({\posx{-1}{\rowI}{0}{\cellI}},{\posy{1}{\numexpr\rowI - 1\relax}}) -- ({\posx{-1}{\rowI}{0}{\cellI}},{\posy{-1}{\rowI}});%
                \fi
              }
            \fi
          }
          \draw[line width=0.2mm,draw=\xput@gridcolor,opacity=\xput@gridopacity] ({\xput@gridx},{\xput@gridy}) rectangle ({\xput@gridxx},{\xput@gridyy});%
          \ifdim\xput@gridoffsethorizontal>0.001pt
            \draw[line width=0.2mm,dash pattern={on 1mm off 1mm},draw=\xput@gridcolor,opacity=\xput@gridopacity] (\xput@gridx,\xput@gridy) -- (\xput@gridx-\xput@gridoffsethorizontal,\xput@gridy) -- (\xput@gridx-\xput@gridoffsethorizontal,\xput@gridyy) -- (\xput@gridx,\xput@gridyy);%
          \fi
          \ifdim\xput@gridoffsethorizontaln>0.001pt
            \draw[line width=0.2mm,dash pattern={on 1mm off 1mm},draw=\xput@gridcolor,opacity=\xput@gridopacity] (\xput@gridxx,\xput@gridy) -- (\xput@gridxx+\xput@gridoffsethorizontaln,\xput@gridy) -- (\xput@gridxx+\xput@gridoffsethorizontaln,\xput@gridyy) -- (\xput@gridxx,\xput@gridyy);%
          \fi
          \ifdim\xput@gridoffsetvertical>0.001pt
            \draw[line width=0.2mm,dash pattern={on 1mm off 1mm},draw=\xput@gridcolor,opacity=\xput@gridopacity]  (\xput@gridx,\xput@gridy) -- (\xput@gridx,\xput@gridy+\xput@gridoffsetvertical)-- (\xput@gridxx,\xput@gridy+\xput@gridoffsetvertical) -- (\xput@gridxx,\xput@gridy);%
          \fi
          \ifdim\xput@gridoffsetverticaln>0.001pt
            \draw[line width=0.2mm,dash pattern={on 1mm off 1mm},draw=\xput@gridcolor,opacity=\xput@gridopacity] ({\xput@gridx},{\xput@gridyy}) --({\xput@gridx},{\xput@gridyy-\xput@gridoffsetverticaln}) -- ({\xput@gridxx},{\xput@gridyy-\xput@gridoffsetverticaln}) -- ({\xput@gridxx},{\xput@gridyy});%
          \fi
        \end{tikzpicture}%
      }
    \fi
  \fi
}
\def\xput@bleedcolor{red}
\def\xput@bleedopacity{0.5}
\newif\ifxput@putbleed
\newcommand\xput@checkbleed{
  \ifdim\xput@topbleed>\xput@null
    \xput@putbleedtrue
  \else
    \ifdim\xput@bottombleed>\xput@null
      \xput@putbleedtrue
    \else
      \ifdim\xput@innerbleed>\xput@null
        \xput@putbleedtrue
      \else
        \ifdim\xput@outerbleed>\xput@null
          \xput@putbleedtrue
        \else
          \xput@putbleedfalse
        \fi
      \fi
    \fi
  \fi
}
\newcommand\xput@putbleed{
  \ifxput@isemptypage
  \else
    \ifxput@safezone
      \xput@checkbleed
      \ifxput@putbleed
        \put(0,0){%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%

            \ifxput@frontcover
              \ifxput@backcover
                \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (0, \xput@pageheight + \xput@bottombleed) rectangle ++(\xput@pagewidth + \xput@outerbleed,\xput@topbleed);%
                \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (0, 0) rectangle ++(\xput@pagewidth + \xput@outerbleed,\xput@bottombleed);%
                \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (0, \xput@bottombleed) rectangle ++(\xput@outerbleed,\xput@pageheight);%
              \else
                \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (\xput@pagewidth + \xput@outerbleed, \xput@pageheight + \xput@bottombleed) rectangle ++(\xput@pagewidth + \xput@outerbleed + \spinewidth,\xput@topbleed);%
                \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (\xput@pagewidth + \xput@outerbleed, 0) rectangle ++(\xput@pagewidth + \xput@outerbleed + \spinewidth,\xput@bottombleed);%
                \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (\xput@pagewidth * 2 + \xput@outerbleed + \spinewidth, \xput@bottombleed) rectangle ++(\xput@outerbleed,\xput@pageheight);%
              \fi
            \else
              \ifxput@fanfold
                \ifxput@isdoublepage
                  \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (0, \xput@pageheight + \xput@bottombleed) rectangle ++(\xput@pagewidth * 2 + \xput@outerbleed * 2,\xput@topbleed);%
                  \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (0, 0) rectangle ++(\xput@pagewidth * 2 + \xput@outerbleed * 2,\xput@bottombleed);%
                  \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (0, \xput@bottombleed) rectangle ++(\xput@outerbleed,\xput@pageheight);%
                  \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (\xput@pagewidth * 2 + \xput@outerbleed, \xput@bottombleed) rectangle ++(\xput@outerbleed,\xput@pageheight);%
                \else
                  \ifxput@leftpage
                    \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (0, \xput@pageheight + \xput@bottombleed) rectangle ++(\xput@pagewidth + \xput@outerbleed,\xput@topbleed);%
                    \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (0, 0) rectangle ++(\xput@pagewidth + \xput@outerbleed,\xput@bottombleed);%
                    \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (0, \xput@bottombleed) rectangle ++(\xput@outerbleed,\xput@pageheight);%
                  \else
                    \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (\xput@pagewidth + \xput@outerbleed, \xput@pageheight + \xput@bottombleed) rectangle ++(\xput@pagewidth + \xput@outerbleed,\xput@topbleed);%
                    \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (\xput@pagewidth + \xput@outerbleed, 0) rectangle ++(\xput@pagewidth + \xput@outerbleed,\xput@bottombleed);%
                    \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (\xput@pagewidth * 2 + \xput@outerbleed, \xput@bottombleed) rectangle ++(\xput@outerbleed,\xput@pageheight);%
                  \fi
                \fi
              \else
                \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (0, \xput@pageheight + \xput@bottombleed) rectangle ++(\xput@pagewidth + \xput@leftbleed + \xput@rightbleed,\xput@topbleed);%
                \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (0, 0) rectangle ++(\xput@pagewidth + \xput@leftbleed + \xput@rightbleed,\xput@bottombleed);%
                \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (0, \xput@bottombleed) rectangle ++(\xput@leftbleed,\xput@pageheight);%
                \fill[\xput@bleedcolor,opacity=\xput@bleedopacity] (\xput@pagewidth + \xput@leftbleed, \xput@bottombleed) rectangle ++(\xput@rightbleed,\xput@pageheight);%
              \fi
            \fi
          \end{tikzpicture}%
        }
      \fi
    \fi
  \fi
}
\newdimen\xput@cuttingmarka
\newdimen\xput@cuttingmarkb
\xput@cuttingmarka=-3mm
\xput@cuttingmarkb=-1mm
\newcommand\xput@putcuttingmarks{
  \ifxput@isemptypage
    \ifxput@fanfold
      \xput@cuttingmarksvisibletrue
    \fi
  \else
    \xput@cuttingmarksvisibletrue
  \fi
  \ifxput@cuttingmarksvisible
    \ifxput@cuttingmarks
      \ifxput@safezone
      \else
        \xput@checkbleed
        \ifxput@putbleed
          \put(0,0){%
            \begin{tikzpicture}%
              \pgflowlevelsynccm%

              \ifxput@frontcover
                \ifxput@backcover
                  \draw[\xput@pageoptioncolor,line width=0.15mm](\xput@outerbleed + \xput@cuttingmarka, \xput@bottombleed) -- (\xput@outerbleed + \xput@cuttingmarkb, \xput@bottombleed);%
                  \draw[\xput@pageoptioncolor,line width=0.15mm](\xput@outerbleed, \xput@bottombleed + \xput@cuttingmarka) -- (\xput@outerbleed, \xput@bottombleed + \xput@cuttingmarkb);%
                  \draw[\xput@pageoptioncolor](\xput@outerbleed + \xput@cuttingmarka, \xput@bottombleed+\xput@pageheight) -- (\xput@outerbleed + \xput@cuttingmarkb, \xput@bottombleed + \xput@pageheight);%
                  \draw[\xput@pageoptioncolor](\xput@outerbleed, \xput@bottombleed + \xput@pageheight - \xput@cuttingmarka) -- (\xput@outerbleed, \xput@bottombleed + \xput@pageheight - \xput@cuttingmarkb);%
                \else
                  \draw[\xput@pageoptioncolor](2\xput@pagewidth + \xput@outerbleed + \spinewidth - \xput@cuttingmarka, \xput@bottombleed) -- (2\xput@pagewidth + \xput@outerbleed + \spinewidth - \xput@cuttingmarkb, \xput@bottombleed);%
                  \draw[\xput@pageoptioncolor](2\xput@pagewidth + \xput@outerbleed + \spinewidth, \xput@bottombleed + \xput@cuttingmarka) -- (2\xput@pagewidth + \xput@outerbleed + \spinewidth, \xput@bottombleed + \xput@cuttingmarkb);%
                  \draw[\xput@pageoptioncolor](2\xput@pagewidth + \xput@outerbleed + \spinewidth - \xput@cuttingmarka, \xput@bottombleed+\xput@pageheight) -- (2\xput@pagewidth + \xput@outerbleed + \spinewidth - \xput@cuttingmarkb, \xput@bottombleed+\xput@pageheight);%
                  \draw[\xput@pageoptioncolor](2\xput@pagewidth + \xput@outerbleed + \spinewidth, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarka) -- (2\xput@pagewidth + \xput@outerbleed + \spinewidth, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarkb);%
                \fi
              \else
                \ifxput@fanfold
                  \ifxput@isdoublepage
                    \draw[\xput@pageoptioncolor](\xput@outerbleed + \xput@cuttingmarka, \xput@bottombleed) -- (\xput@outerbleed + \xput@cuttingmarkb, \xput@bottombleed);%
                    \draw[\xput@pageoptioncolor](\xput@outerbleed, \xput@bottombleed + \xput@cuttingmarka) -- (\xput@outerbleed, \xput@bottombleed + \xput@cuttingmarkb);%
                    \draw[\xput@pageoptioncolor](\xput@outerbleed + \xput@cuttingmarka, \xput@bottombleed+\xput@pageheight) -- (\xput@outerbleed + \xput@cuttingmarkb, \xput@bottombleed+\xput@pageheight);%
                    \draw[\xput@pageoptioncolor](\xput@outerbleed, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarka) -- (\xput@outerbleed, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarkb);%

                    \draw[\xput@pageoptioncolor](2\xput@pagewidth + \xput@outerbleed - \xput@cuttingmarka, \xput@bottombleed) -- (2\xput@pagewidth + \xput@outerbleed - \xput@cuttingmarkb, \xput@bottombleed);%
                    \draw[\xput@pageoptioncolor](2\xput@pagewidth + \xput@outerbleed, \xput@bottombleed + \xput@cuttingmarka) -- (2\xput@pagewidth + \xput@outerbleed, \xput@bottombleed + \xput@cuttingmarkb);%
                    \draw[\xput@pageoptioncolor](2\xput@pagewidth + \xput@outerbleed - \xput@cuttingmarka, \xput@bottombleed+\xput@pageheight) -- (2\xput@pagewidth + \xput@outerbleed - \xput@cuttingmarkb, \xput@bottombleed+\xput@pageheight);%
                    \draw[\xput@pageoptioncolor](2\xput@pagewidth + \xput@outerbleed, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarka) -- (2\xput@pagewidth + \xput@outerbleed, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarkb);%
                  \else
                    \ifxput@leftpage
                      \draw[\xput@pageoptioncolor](\xput@outerbleed + \xput@cuttingmarka, \xput@bottombleed) -- (\xput@outerbleed + \xput@cuttingmarkb, \xput@bottombleed);%
                      \draw[\xput@pageoptioncolor](\xput@outerbleed, \xput@bottombleed + \xput@cuttingmarka) -- (\xput@outerbleed, \xput@bottombleed + \xput@cuttingmarkb);%
                      \draw[\xput@pageoptioncolor](\xput@outerbleed + \xput@cuttingmarka, \xput@bottombleed+\xput@pageheight) -- (\xput@outerbleed + \xput@cuttingmarkb, \xput@bottombleed+\xput@pageheight);%
                      \draw[\xput@pageoptioncolor](\xput@outerbleed, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarka) -- (\xput@outerbleed, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarkb);%
                    \else
                      \draw[\xput@pageoptioncolor](2\xput@pagewidth + \xput@outerbleed - \xput@cuttingmarka, \xput@bottombleed) -- (2\xput@pagewidth + \xput@outerbleed - \xput@cuttingmarkb, \xput@bottombleed);%
                      \draw[\xput@pageoptioncolor](2\xput@pagewidth + \xput@outerbleed, \xput@bottombleed + \xput@cuttingmarka) -- (2\xput@pagewidth + \xput@outerbleed, \xput@bottombleed + \xput@cuttingmarkb);%
                      \draw[\xput@pageoptioncolor](2\xput@pagewidth + \xput@outerbleed - \xput@cuttingmarka, \xput@bottombleed+\xput@pageheight) -- (2\xput@pagewidth + \xput@outerbleed - \xput@cuttingmarkb, \xput@bottombleed+\xput@pageheight);%
                      \draw[\xput@pageoptioncolor](2\xput@pagewidth + \xput@outerbleed, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarka) -- (2\xput@pagewidth + \xput@outerbleed, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarkb);%
                    \fi
                  \fi
                \else
                  \draw[\xput@pageoptioncolor](\xput@outerbleed + \xput@cuttingmarka, \xput@bottombleed) -- (\xput@outerbleed + \xput@cuttingmarkb, \xput@bottombleed);%
                  \draw[\xput@pageoptioncolor](\xput@outerbleed, \xput@bottombleed + \xput@cuttingmarka) -- (\xput@outerbleed, \xput@bottombleed + \xput@cuttingmarkb);%
                  \draw[\xput@pageoptioncolor](\xput@outerbleed + \xput@cuttingmarka, \xput@bottombleed+\xput@pageheight) -- (\xput@outerbleed + \xput@cuttingmarkb, \xput@bottombleed+\xput@pageheight);%
                  \draw[\xput@pageoptioncolor](\xput@outerbleed, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarka) -- (\xput@outerbleed, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarkb);%
                  \draw[\xput@pageoptioncolor](\xput@pagewidth + \xput@outerbleed - \xput@cuttingmarka, \xput@bottombleed) -- (\xput@pagewidth + \xput@outerbleed - \xput@cuttingmarkb, \xput@bottombleed);%
                  \draw[\xput@pageoptioncolor](\xput@pagewidth + \xput@outerbleed, \xput@bottombleed + \xput@cuttingmarka) -- (\xput@pagewidth + \xput@outerbleed, \xput@bottombleed + \xput@cuttingmarkb);%
                  \draw[\xput@pageoptioncolor](\xput@pagewidth + \xput@outerbleed - \xput@cuttingmarka, \xput@bottombleed+\xput@pageheight) -- (\xput@pagewidth + \xput@outerbleed - \xput@cuttingmarkb, \xput@bottombleed+\xput@pageheight);%
                  \draw[\xput@pageoptioncolor](\xput@pagewidth + \xput@outerbleed, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarka) -- (\xput@pagewidth + \xput@outerbleed, \xput@bottombleed+\xput@pageheight - \xput@cuttingmarkb);%
                \fi
              \fi
            \end{tikzpicture}%
          }
        \fi
      \fi
    \fi
  \fi
}
\def\xput@safetymargincolor{pink}
\def\xput@safetymarginopacity{0.8}
\newif\ifxput@putsafezone
\newcommand\xput@checksafezone{
  \ifdim\xput@topsafetymargin>\xput@null
    \xput@putsafezonetrue
  \else
    \ifdim\xput@bottomsafetymargin>\xput@null
      \xput@putsafezonetrue
    \else
      \ifdim\xput@innersafetymargin>\xput@null
        \xput@putsafezonetrue
      \else
        \ifdim\xput@outersafetymargin>\xput@null
          \xput@putsafezonetrue
        \else
          \xput@putsafezonefalse
        \fi
      \fi
    \fi
  \fi
}
\newcommand\xput@putsafezone{
  \ifxput@isemptypage
  \else
    \ifxput@safezone
      \xput@checksafezone
      \ifxput@putsafezone
        \put(0,0){%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%

            \ifxput@frontcover
              \ifxput@backcover
              \else
                \draw[line cap=rect,line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\xput@pagewidth + \xput@outerbleed,0.05mm) -- (\xput@pagewidth + \xput@outerbleed,\paperheight-0.05mm);%
                \draw[line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\xput@outersafetymargin + \xput@outerbleed,\xput@bottomsafetymargin + \xput@bottombleed) rectangle (\xput@pagewidth + \xput@outerbleed - \xput@innersafetymargin,\paperheight - \xput@topsafetymargin - \xput@topbleed);%
                \draw[line cap=rect,line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\xput@pagewidth + \xput@outerbleed + \spinewidth,0.05mm) -- (\xput@pagewidth + \xput@outerbleed + \spinewidth,\paperheight-0.05mm);%
                \draw[line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\xput@pagewidth + \xput@outerbleed + \spinewidth + \xput@innersafetymargin,\xput@bottomsafetymargin + \xput@bottombleed) rectangle (\paperwidth - \xput@outerbleed - \xput@outersafetymargin,\paperheight - \xput@topsafetymargin - \xput@topbleed);%
              \fi
            \else
              \ifxput@fanfold
                \ifxput@isdoublepage
                  \draw[line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\xput@outersafetymargin + \xput@outerbleed,\xput@bottomsafetymargin + \xput@bottombleed) rectangle (\paperwidth / 2 - \xput@innersafetymargin,\paperheight - \xput@topsafetymargin - \xput@topbleed);%
                  \draw[line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\paperwidth / 2 + \xput@innersafetymargin,\xput@bottomsafetymargin + \xput@bottombleed) rectangle (\paperwidth - \xput@outerbleed - \xput@outersafetymargin,\paperheight - \xput@topsafetymargin - \xput@topbleed);%
                \else
                  \ifxput@leftpage
                    \draw[line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\xput@outersafetymargin + \xput@outerbleed,\xput@bottomsafetymargin + \xput@bottombleed) rectangle (\paperwidth / 2 - \xput@innersafetymargin,\paperheight - \xput@topsafetymargin - \xput@topbleed);%
                  \else
                    \draw[line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\paperwidth / 2 + \xput@innersafetymargin,\xput@bottomsafetymargin + \xput@bottombleed) rectangle (\paperwidth - \xput@outerbleed - \xput@outersafetymargin,\paperheight - \xput@topsafetymargin - \xput@topbleed);%
                  \fi
                \fi
                \draw[line cap=rect,line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\paperwidth / 2,0.05mm) -- (\paperwidth / 2,\paperheight-0.05mm);%
              \else
                \draw[line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\xput@leftsafetymargin + \xput@leftbleed,\xput@bottomsafetymargin + \xput@bottombleed) rectangle (\paperwidth - \xput@rightsafetymargin - \xput@rightbleed,\paperheight - \xput@topsafetymargin - \xput@topbleed);%
              \fi
            \fi
          \end{tikzpicture}%
        }
      \else
        \ifxput@frontcover
          \ifxput@backcover
          \else
            \put(0,0){%
              \begin{tikzpicture}%
                \pgflowlevelsynccm%
                \draw[line cap=rect,line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\xput@pagewidth + \xput@outerbleed,0.05mm) -- (\xput@pagewidth + \xput@outerbleed,\paperheight-0.05mm);%
                \draw[line cap=rect,line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\xput@pagewidth + \xput@outerbleed + \spinewidth,0.05mm) -- (\xput@pagewidth + \xput@outerbleed + \spinewidth,\paperheight-0.05mm);%
              \end{tikzpicture}%
            }
          \fi
        \else
          \ifxput@fanfold
            \put(0,0){%
              \begin{tikzpicture}%
                \pgflowlevelsynccm%
                \draw[line cap=rect,line width=0.1mm,draw=\xput@safetymargincolor,opacity=\xput@safetymarginopacity] (\paperwidth / 2,0.05mm) -- (\paperwidth / 2,\paperheight-0.05mm);%
              \end{tikzpicture}%
            }
          \fi
        \fi
      \fi
    \fi
  \fi
}
\def\xput@graphpapercolor{gray!70}
\def\xput@graphpaperopacity{0.2}
\newcommand\xput@calcgraphpaperx{
  \ifdim\xput@graphpaperx>\xput@null
    \xput@graphpaperx=\dimexpr\xput@graphpaperx-\xput@graphpapersnap\relax
    \xput@calcgraphpaperx
  \fi
}
\newcommand\xput@calcgraphpapery{
  \ifdim\xput@graphpapery>\xput@null
    \xput@graphpapery=\dimexpr\xput@graphpapery-\xput@graphpapersnap\relax
    \xput@calcgraphpapery
  \fi
}
\newcommand\xput@calcgraphpaperoffset{
  \xput@graphpaperoffset=\xput@null

  \xput@graphpaperoffsetsnap \numexpr\number\xput@pagewidth/\xput@graphpapersnap\relax
  \xput@graphpaperoffset=\dimexpr\xput@pagewidth-\xput@graphpapersnap*\xput@graphpaperoffsetsnap\relax
  \ifdim\xput@graphpaperoffset<\xput@null
    \xput@graphpaperoffset=\dimexpr\xput@graphpaperoffset+\xput@graphpapersnap\relax
  \fi
  \xput@graphpaperx=\dimexpr\xput@graphpaperx-\xput@graphpaperoffset\relax
}
\newcount\xput@graphpaperoffsetsnap
\newcommand\xput@putgraphpaper{
  \ifxput@graphpaper
    \xput@graphpapery=\xput@bottombleed
    \xput@calcgraphpapery
    \xput@graphpaperx=\xput@leftbleed
    \xput@calcgraphpaperx

    \ifxput@frontcover
      \ifxput@backcover
        \put(\xput@dimentonumber{\xput@graphpaperx},\xput@dimentonumber{\xput@graphpapery}){%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%

            \foreach \xput@graphpaperconfigitem in \xput@graphpaperconfig {
              \draw[line cap=rect,line width=0.05mm,step=\xput@graphpaperconfigitem,\xput@graphpapercolor,opacity=\xput@graphpaperopacity] (0pt,0pt) grid ++(\xput@pagewidth-\xput@graphpaperx+\xput@outerbleed,\paperheight-\xput@graphpapery);%
            }
          \end{tikzpicture}%
        }
      \else
        \xput@graphpaperx=\dimexpr\xput@pagewidth+\xput@outerbleed\relax
        \put(\xput@dimentonumber{\xput@graphpaperx},\xput@dimentonumber{\xput@graphpapery}){%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%

            \foreach \xput@graphpaperconfigitem in \xput@graphpaperconfig {
              \draw[line cap=rect,line width=0.05mm,step=\xput@graphpaperconfigitem,\xput@graphpapercolor,opacity=\xput@graphpaperopacity] (0pt,0pt) grid ++(\spinewidth,\paperheight-\xput@graphpapery);%
            }
          \end{tikzpicture}%
        }
        \xput@graphpaperx=\dimexpr\xput@pagewidth+\xput@outerbleed+\spinewidth\relax
        \put(\xput@dimentonumber{\xput@graphpaperx},\xput@dimentonumber{\xput@graphpapery}){%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%

            \foreach \xput@graphpaperconfigitem in \xput@graphpaperconfig {
              \draw[line cap=rect,line width=0.05mm,step=\xput@graphpaperconfigitem,\xput@graphpapercolor,opacity=\xput@graphpaperopacity] (0pt,0pt) grid ++(\xput@pagewidth+\xput@outerbleed,\paperheight-\xput@graphpapery);%
            }
          \end{tikzpicture}%
        }
      \fi
    \else
      \ifxput@fanfold
        \ifxput@isdoublepage
          \put(\xput@dimentonumber{\xput@graphpaperx},\xput@dimentonumber{\xput@graphpapery}){%
            \begin{tikzpicture}%
              \pgflowlevelsynccm%

              \foreach \xput@graphpaperconfigitem in \xput@graphpaperconfig {
                \draw[line cap=rect,line width=0.05mm,step=\xput@graphpaperconfigitem,\xput@graphpapercolor,opacity=\xput@graphpaperopacity] (0pt,0pt) grid ++(\paperwidth-\xput@graphpaperx,\paperheight-\xput@graphpapery);%
              }
            \end{tikzpicture}%
          }
        \else
          \ifxput@leftpage
            \put(\xput@dimentonumber{\xput@graphpaperx},\xput@dimentonumber{\xput@graphpapery}){%
              \begin{tikzpicture}%
                \pgflowlevelsynccm%

                \foreach \xput@graphpaperconfigitem in \xput@graphpaperconfig {
                  \draw[line cap=rect,line width=0.05mm,step=\xput@graphpaperconfigitem,\xput@graphpapercolor,opacity=\xput@graphpaperopacity] (0pt,0pt) grid ++(\xput@pagewidth-\xput@graphpaperx+\xput@outerbleed,\paperheight-\xput@graphpapery);%
                }
              \end{tikzpicture}%
            }
          \else
            \xput@graphpaperx=\dimexpr\xput@pagewidth+\xput@outerbleed\relax
            \put(\xput@dimentonumber{\xput@graphpaperx},\xput@dimentonumber{\xput@graphpapery}){%
              \begin{tikzpicture}%
                \pgflowlevelsynccm%

                \foreach \xput@graphpaperconfigitem in \xput@graphpaperconfig {
                  \draw[line cap=rect,line width=0.05mm,step=\xput@graphpaperconfigitem,\xput@graphpapercolor,opacity=\xput@graphpaperopacity] (0pt,0pt) grid ++(\xput@pagewidth+\xput@outerbleed,\paperheight-\xput@graphpapery);%
                }
              \end{tikzpicture}%
            }
          \fi
        \fi
      \else
        \ifxput@isdoublepage
          \ifxput@rightpage
            \xput@calcgraphpaperoffset
          \fi
        \fi

        \put(\xput@dimentonumber{\xput@graphpaperx},\xput@dimentonumber{\xput@graphpapery}){%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%

            \foreach \xput@graphpaperconfigitem in \xput@graphpaperconfig {
              \draw[line cap=rect,line width=0.05mm,step=\xput@graphpaperconfigitem,\xput@graphpapercolor,opacity=\xput@graphpaperopacity] (0pt,0pt) grid ++(\paperwidth-\xput@graphpaperx,\paperheight-\xput@graphpapery);%
            }
          \end{tikzpicture}%
        }
      \fi
    \fi
  \fi
}

% pages
\newif\ifxput@isbeforepage
\def\xput@currentbeforepage{}
\newcommand\setbeforepage[1]{
  \ifxput@ispage
    \def\xput@currentbeforepage{#1}
  \else
    \global\def\xput@currentbeforepage{#1}
  \fi
}
\def\nobeforepage{\setbeforepage{}}
\newcommand\newbeforepage[2]{
  \expandafter\newcommand\csname xput@before@#1\endcsname{%
    \begingroup%
      #2
    \endgroup%
  }%
}
\newcommand\xput@putbeforepage{
  \ifx\xput@pagegraphic\xput@emptystring
  \else
    \xput@putpagegraphic
  \fi
  \ifx\xput@currentbeforepage\xput@emptystring
  \else
    \ifcsname xput@before@\xput@currentbeforepage\endcsname%
      \xput@isbeforepagetrue
      \csname xput@before@\xput@currentbeforepage\endcsname
      \xput@isbeforepagefalse
    \else
      \xput@errmsg@undefined{before page}{\xput@currentbeforepage}
    \fi
  \fi
  \xput@resetautogrid
}
\newcommand\xput@beforepage{
  \xput@closerows
  \ifx\xput@pagecolor\xput@emptystring
  \else
    \begingroup
      \margin=\xput@null
      \topmargin=\xput@null
      \bottommargin=\xput@null
      \innermargin=\xput@null
      \outermargin=\xput@null
      \setgrid{{{1}}}
      \ifx\xput@pagecolormodel\xput@emptystring
      \else
        \definecolor{tmpcolor}{\xput@pagecolormodel}{\xput@pagecolor}
        \setpagecolor{tmpcolor}
      \fi
      \xput@putxput[1]{0}{0}{1}{1}{%
        \begin{tikzpicture}%
          \pgflowlevelsynccm%
          \fill[\xput@pagecolor] (0,0) rectangle ++(\width,\height);
        \end{tikzpicture}%
      }
    \endgroup
  \fi

  \ifxput@isemptypage
  \else
    \xput@putgraphpaper
  \fi
}
\newcommand\xput@setuppage{
  \global\gutter=\gutter
  \global\margin=\margin
  \global\innermargin=\innermargin
  \global\outermargin=\outermargin
  \global\bottommargin=\bottommargin
  \global\topmargin=\topmargin
  \ifxput@grid\global\xput@gridtrue\else\global\xput@gridfalse\fi
  \ifxput@graphpaper\global\xput@graphpapertrue\else\global\xput@graphpaperfalse\fi
  \ifxput@safezone\global\xput@safezonetrue\else\global\xput@safezonefalse\fi
  \ifxput@placeholder\global\xput@placeholdertrue\else\global\xput@placeholderfalse\fi
  \global\let\xput@defaultborderwidth\xput@defaultborderwidth
  \global\let\xput@defaultborderradius\xput@defaultborderradius
  \global\let\xput@defaultborderopacity\xput@defaultborderopacity
  \global\let\xput@defaultbordercolor\xput@defaultbordercolor
  \global\let\xput@defaultshadowsize\xput@defaultshadowsize
  \global\let\xput@defaultshadowopacity\xput@defaultshadowopacity
  \global\let\xput@defaultshadowcolor\xput@defaultshadowcolor
  \global\let\xput@defaultshadowxshift\xput@defaultshadowxshift
  \global\let\xput@defaultshadowyshift\xput@defaultshadowyshift
  \global\let\xput@pagegraphicoptionscale\xput@pagegraphicoptionscale
  \global\let\xput@pagegraphicoptionvpos\xput@pagegraphicoptionvpos
  \global\let\xput@pagegraphicoptionhpos\xput@pagegraphicoptionhpos
  \global\let\xput@pagegraphicoptionunsharp\xput@pagegraphicoptionunsharp

  \xput@pagewidth=\pagewidth
  \xput@pageheight=\pageheight
  \xput@outerbleed=\ifdim\outerbleed=\xput@undefdim\bleed\else\outerbleed\fi
  \xput@innerbleed=\ifdim\innerbleed=\xput@undefdim\bleed\else\innerbleed\fi
  \xput@topbleed=\ifdim\topbleed=\xput@undefdim\bleed\else\topbleed\fi
  \xput@bottombleed=\ifdim\bottombleed=\xput@undefdim\bleed\else\bottombleed\fi
  \xput@outersafetymargin=\ifdim\outersafetymargin=\xput@undefdim\safetymargin\else\outersafetymargin\fi
  \xput@innersafetymargin=\ifdim\innersafetymargin=\xput@undefdim\safetymargin\else\innersafetymargin\fi
  \xput@topsafetymargin=\ifdim\topsafetymargin=\xput@undefdim\safetymargin\else\topsafetymargin\fi
  \xput@bottomsafetymargin=\ifdim\bottomsafetymargin=\xput@undefdim\safetymargin\else\bottomsafetymargin\fi

  \ifxput@haspages
    \ifxput@twoside
      \ifxput@leftpage
        \global\xput@rightpagetrue
        \global\xput@leftpagefalse
      \else
        \global\xput@rightpagefalse
        \global\xput@leftpagetrue
      \fi
    \fi
  \else
    \xput@isinitgridfalse
    \ifxput@beginleft
      \global\xput@leftpagetrue
    \fi
    \ifxput@beginright
      \global\xput@beginleftfalse
      \global\xput@beginrightfalse
      \global\xput@leftpagefalse
    \fi
    \ifxput@leftpage
      \xput@haspagestrue
      \global\xput@leftpagetrue
      \global\xput@rightpagefalse
    \else
      \ifxput@fanfold
        \global\xput@rightpagefalse
        \global\xput@leftpagetrue
        \setcounter{page}{0}
        \xput@emptypage
        \global\xput@rightpagetrue
        \global\xput@leftpagefalse
        \global\xput@haslastemptypagetrue
      \else
        \ifxput@hascover
          \ifxput@fillpages
            \ifxput@twoside
              \global\xput@rightpagefalse
              \global\xput@leftpagetrue
              \setcounter{page}{0}
              \xput@emptypage
              \global\xput@rightpagetrue
              \global\xput@leftpagefalse
              \global\xput@haslastemptypagetrue
            \else
              \xput@haspagestrue
              \global\xput@rightpagetrue
            \fi
          \else
            \xput@haspagestrue
            \global\xput@rightpagetrue
          \fi
        \else
          \xput@haspagestrue
          \global\xput@rightpagetrue
        \fi
      \fi
    \fi
  \fi
}
\newcommand\xput@setupcover{
  \xput@isinitgridfalse
  \xput@pagewidth=\ifdim\coverwidth=\xput@undefdim\pagewidth\else\coverwidth\fi
  \xput@pageheight=\ifdim\coverheight=\xput@undefdim\pageheight\else\coverheight\fi
  \xput@outerbleed=\ifdim\coverouterbleed=\xput@undefdim\ifdim\coverbleed=\xput@undefdim\ifdim\outerbleed=\xput@undefdim\bleed\else\outerbleed\fi\else\coverbleed\fi\else\coverouterbleed\fi
  \xput@innerbleed=\ifdim\coverinnerbleed=\xput@undefdim\ifdim\coverbleed=\xput@undefdim\ifdim\innerbleed=\xput@undefdim\bleed\else\innerbleed\fi\else\coverbleed\fi\else\coverinnerbleed\fi
  \xput@topbleed=\ifdim\covertopbleed=\xput@undefdim\ifdim\coverbleed=\xput@undefdim\ifdim\topbleed=\xput@undefdim\bleed\else\topbleed\fi\else\coverbleed\fi\else\covertopbleed\fi
  \xput@bottombleed=\ifdim\coverbottombleed=\xput@undefdim\ifdim\coverbleed=\xput@undefdim\ifdim\bottombleed=\xput@undefdim\bleed\else\bottombleed\fi\else\coverbleed\fi\else\coverbottombleed\fi
  \xput@outersafetymargin=\ifdim\coveroutersafetymargin=\xput@undefdim\ifdim\coversafetymargin=\xput@undefdim\ifdim\outersafetymargin=\xput@undefdim\safetymargin\else\outersafetymargin\fi\else\coversafetymargin\fi\else\coveroutersafetymargin\fi
  \xput@innersafetymargin=\ifdim\coverinnersafetymargin=\xput@undefdim\ifdim\coversafetymargin=\xput@undefdim\ifdim\innersafetymargin=\xput@undefdim\safetymargin\else\innersafetymargin\fi\else\coversafetymargin\fi\else\coverinnersafetymargin\fi
  \xput@topsafetymargin=\ifdim\covertopsafetymargin=\xput@undefdim\ifdim\coversafetymargin=\xput@undefdim\ifdim\topsafetymargin=\xput@undefdim\safetymargin\else\topsafetymargin\fi\else\coversafetymargin\fi\else\covertopsafetymargin\fi
  \xput@bottomsafetymargin=\ifdim\coverbottomsafetymargin=\xput@undefdim\ifdim\coversafetymargin=\xput@undefdim\ifdim\bottomsafetymargin=\xput@undefdim\safetymargin\else\bottomsafetymargin\fi\else\coversafetymargin\fi\else\coverbottomsafetymargin\fi
}
\newif\ifxput@pageoptiondouble
\newif\ifxput@pageoptionfrontcover
\newif\ifxput@pageoptionbackcover
\newdimen\xput@backcovergutter
\newdimen\xput@backcovermargin
\newdimen\xput@backcovertopmargin
\newdimen\xput@backcoverbottommargin
\newdimen\xput@backcoverinnermargin
\newdimen\xput@backcoveroutermargin
\pgfkeys{
  /pagetype/.is family,
  /pagetype,
  double/.is if=xput@pageoptiondouble,
  front cover/.is if=xput@pageoptionfrontcover,
  back cover/.is if=xput@pageoptionbackcover,
  .unknown/.code=
}
\pgfkeys{
  /page/.is family,
  /page,
  gutter/.store in=\xput@pageoptiongutter,
  gutter=\gutter,
  margin/.store in=\xput@pageoptionmargin,
  margin=\margin,
  top margin/.store in=\xput@pageoptiontopmargin,
  top margin=\topmargin,
  bottom margin/.store in=\xput@pageoptionbottommargin,
  bottom margin=\bottommargin,
  inner margin/.store in=\xput@pageoptioninnermargin,
  inner margin=\innermargin,
  outer margin/.store in=\xput@pageoptionoutermargin,
  outer margin=\outermargin,
  vpos/.code={\xput@gridvalign{#1}},
  hpos/.code={\xput@gridhalign{#1}},
  color/.store in=\xput@pageoptioncolor,
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
  gutter/.store in=\xput@backcoveroptiongutter,
  gutter=\gutter,
  margin/.store in=\xput@backcoveroptionmargin,
  margin=\margin,
  top margin/.store in=\xput@backcoveroptiontopmargin,
  top margin=\topmargin,
  bottom margin/.store in=\xput@backcoveroptionbottommargin,
  bottom margin=\bottommargin,
  inner margin/.store in=\xput@backcoveroptioninnermargin,
  inner margin=\innermargin,
  outer margin/.store in=\xput@backcoveroptionoutermargin,
  outer margin=\outermargin,
  vpos/.store in=\xput@backcoveroptionvpos,
  vpos=0.5,
  hpos/.store in=\xput@backcoveroptionhpos,
  hpos=0.5,
  color/.store in=\xput@backcoveroptioncolor,
  color=,
  page color/.store in=\xput@backcoveroptionpagecolor,
  page color=,
  page graphic/.store in=\xput@backcoveroptionpagegraphic,
  page graphic=,
  before page/.code={},
  double/.code={},
  front cover/.code={},
  back cover/.code={},
}
\newcommand\xput@applypageoptions[1]{
  \pgfkeys{/page,#1}
  \gutter=\xput@pageoptiongutter
  \margin=\xput@pageoptionmargin
  \topmargin=\xput@pageoptiontopmargin
  \bottommargin=\xput@pageoptionbottommargin
  \innermargin=\xput@pageoptioninnermargin
  \outermargin=\xput@pageoptionoutermargin

  \xput@beforepage
}
\newcommand\xput@applybackcoveroptions{
  \xput@gridvalign{\xput@backcoveroptionvpos}
  \xput@gridhalign{\xput@backcoveroptionhpos}

  \ifx\xput@backcoveroptionpagecolor\xput@emptystring
    \def\xput@pagecolor{}
  \else
    \setpagecolor{\xput@backcoveroptionpagecolor}
  \fi
  \ifx\xput@backcoveroptionpagegraphic\xput@emptystring
    \def\xput@pagegraphic{}
  \else
    \def\xput@pagegraphic{\xput@backcoveroptionpagegraphicfile}
    \def\xput@pagegraphicoptionscale{\xput@backcoveroptionpagegraphicscale}
    \def\xput@pagegraphicoptionvpos{\xput@backcoveroptionpagegraphicvpos}
    \def\xput@pagegraphicoptionhpos{\xput@backcoveroptionpagegraphichpos}
    \def\xput@pagegraphicoptionunsharp{\xput@backcoveroptionpagegraphicunsharp}
  \fi
  \ifx\xput@backcoveroptioncolor\xput@emptystring
    \def\xput@pageoptioncolor{\xput@backcovercolor}
  \else
    \def\xput@pageoptioncolor{\xput@backcoveroptioncolor}
  \fi
  \setborder[radius=\xput@backcoveroptionborderradius,width=\xput@backcoveroptionborderwidth,opacity=\xput@backcoveroptionborderopacity,color=\xput@backcoveroptionbordercolor]{}
  \setshadow[size=\xput@backcoveroptionshadowsize,opacity=\xput@backcoveroptionshadowopacity,color=\xput@backcoveroptionshadowcolor,xshift=\xput@backcoveroptionshadowxshift,yshift=\xput@backcoveroptionshadowyshift]{}
  \gutter=\xput@backcovergutter
  \margin=\xput@backcovermargin
  \topmargin=\xput@backcovertopmargin
  \bottommargin=\xput@backcoverbottommargin
  \innermargin=\xput@backcoverinnermargin
  \outermargin=\xput@backcoveroutermargin

  \ifdefined\xput@backcovergrid
    \xput@backcovergrid
  \fi

  \xput@beforepage
}
\newcommand\page[2][]{
  \xput@pageoptiondoublefalse
  \xput@pageoptionfrontcoverfalse
  \xput@pageoptionbackcoverfalse
  \pgfkeys{/pagetype,#1}
  \ifxput@pageoptiondouble
    \xput@doublepage[#1]{#2}
  \else
    \ifxput@pageoptionfrontcover
      \xput@frontcover[#1]{#2}
    \else
      \ifxput@pageoptionbackcover
        \xput@backcover[#1]{#2}
      \else
        \xput@standardpage[#1]{#2}
      \fi
    \fi
  \fi
}
\newcommand\xput@standardpage[2][]{
  \global\xput@placeholdercounter=0\relax
  \ifxput@backcover
    \xput@setupcover
  \else
    \xput@setuppage
  \fi
  \xput@ispagetrue
  \global\xput@topmargintmp=\topmargin\global\topmargin=\xput@undefdim
  \xput@setdimensions
  \ifxput@fanfold
    \ifxput@leftpage
      \global\xput@isfanfoldopentrue
      \begin{picture}(\xput@dimentonumber\paperwidth,\xput@dimentonumber\paperheight)
    \fi
  \else
    \begin{picture}(\xput@dimentonumber\paperwidth,\xput@dimentonumber\paperheight)
  \fi
  \topmargin=\xput@topmargintmp
  \begingroup
    \ifxput@fanfold
      \ifxput@pagenumberinghaschanged
        \global\xput@pagenumberinghaschangedfalse
      \else
        \ifxput@rightpage
          \global\addtocounter{page}{1}
        \fi
      \fi
    \fi
    \ifxput@backcover
      \xput@applybackcoveroptions
    \else
      \xput@applypageoptions{#1}
    \fi
    \xput@putbeforepage
    #2
    \xput@putbleed
    \xput@putgrid
    \xput@putcuttingmarks
    \xput@putsafezone
  \endgroup
  \ifxput@fanfold
    \ifxput@rightpage
      \ifnum\xput@tocfixpageoffset=-1
        \addtocounter{page}{-1}
      \fi
      \global\xput@isfanfoldopenfalse
      \end{picture}
      \ifnum\xput@tocfixpageoffset=-1
        \addtocounter{page}{1}
        \global\def\xput@tocfixpageoffset{0}
      \fi
    \fi
  \else
    \end{picture}
  \fi
  \global\topmargin=\xput@topmargintmp
  \xput@ispagefalse
}
\newcommand\xput@doublepage[2][]{
  \global\xput@placeholdercounter=0\relax
  \ifxput@twoside
    \ifxput@haspages
      \ifxput@leftpage\page{}\fi
    \else
      \ifxput@beginleft
        \ifxput@beginright
          \page{}
        \fi
      \else
        \page{}
      \fi
    \fi
    \xput@ispagetrue
    \global\xput@isdoublepagetrue
    \xput@setuppage
    \global\xput@topmargintmp=\topmargin\global\topmargin=\xput@undefdim
    \xput@setdimensions
    \begin{picture}(\xput@dimentonumber\paperwidth,\xput@dimentonumber\paperheight)
      \topmargin=\xput@topmargintmp
      \xput@applypageoptions{#1}
      \xput@putbeforepage
      #2
      \xput@putbleed
      \xput@putgrid
      \xput@putcuttingmarks
      \xput@putsafezone
      \ifnum\xput@tocfixpageoffset=1
        \addtocounter{page}{1}
      \fi
    \end{picture}

    \xput@setuppage
    \ifxput@fanfold
      \ifnum\xput@tocfixpageoffset=1
        \global\def\xput@tocfixpageoffset{0}
      \else
        \addtocounter{page}{1}
      \fi
    \else
      \xput@setdimensions
      \begin{picture}(\xput@dimentonumber\paperwidth,\xput@dimentonumber\paperheight)
        \topmargin=\xput@topmargintmp
        \xput@applypageoptions{#1}
        \global\xput@placeholdercounter=0\relax
        \xput@putbeforepage
        #2
        \xput@putbleed
        \xput@putgrid
        \xput@putcuttingmarks
        \xput@putsafezone
      \end{picture}
    \fi
    \global\xput@isdoublepagefalse
    \global\topmargin=\xput@topmargintmp
    \xput@ispagefalse
  \else
    \xput@standardpage[#1]{#2}
  \fi
}
\newcommand\xput@backcover[2][]{
  \ifxput@hascover
    \xput@errmsg@backcoverdefinedafterfrontcover
  \else
    \ifdefined\xput@tmpgrid
      \let\xput@backcovergrid\xput@tmpgrid
    \fi
    \edef\xput@backcovercolor{\xputoptions@color}
    \pgfkeys{/backcover,#1}
    \xput@backcovergutter=\xput@backcoveroptiongutter
    \xput@backcovermargin=\xput@backcoveroptionmargin
    \xput@backcovertopmargin=\xput@backcoveroptiontopmargin
    \xput@backcoverbottommargin=\xput@backcoveroptionbottommargin
    \xput@backcoverinnermargin=\xput@backcoveroptioninnermargin
    \xput@backcoveroutermargin=\xput@backcoveroptionoutermargin
    \ifx\xput@backcoveroptionpagecolor\xput@emptystring
      \let\xput@backcoveroptionpagecolor\xput@pagecolor
    \fi
    \ifx\xput@backcoveroptionpagegraphic\xput@emptystring
      \let\xput@backcoveroptionpagegraphic\xput@pagegraphic
      \let\xput@backcoveroptionpagegraphicfile\xput@pagegraphic
      \ifdefined\xput@pagegraphicoptionscale
        \let\xput@backcoveroptionpagegraphicscale\xput@pagegraphicoptionscale
      \fi
      \ifdefined\xput@pagegraphicoptionhpos
        \let\xput@backcoveroptionpagegraphichpos\xput@pagegraphicoptionhpos
      \fi
      \ifdefined\xput@pagegraphicoptionvpos
        \let\xput@backcoveroptionpagegraphicvpos\xput@pagegraphicoptionvpos
      \fi
      \ifdefined\xput@pagegraphicoptionunsharp
        \let\xput@backcoveroptionpagegraphicunsharp\xput@pagegraphicoptionunsharp
      \fi
    \else
      \ifcsname xput@graphic@\xput@backcoveroptionpagegraphic\endcsname
        \csname xput@graphic@\xput@backcoveroptionpagegraphic\endcsname[1]{}
      \else
        \def\xput@backcoveroptionpagegraphicfile{\xput@backcoveroptionpagegraphic}
        \def\xput@backcoveroptionpagegraphicscale{1}
        \def\xput@backcoveroptionpagegraphichpos{0.5}
        \def\xput@backcoveroptionpagegraphicvpos{0.5}
        \def\xput@backcoveroptionpagegraphicunsharp{\xput@unsharp}
      \fi
    \fi
    \let\xput@backcoveroptionborderradius\xput@defaultborderradius
    \let\xput@backcoveroptionborderopacity\xput@defaultborderopacity
    \let\xput@backcoveroptionborderwidth\xput@defaultborderwidth
    \let\xput@backcoveroptionbordercolor\xput@defaultbordercolor
    \let\xput@backcoveroptionshadowopacity\xput@defaultshadowopacity
    \let\xput@backcoveroptionshadowsize\xput@defaultshadowsize
    \let\xput@backcoveroptionshadowcolor\xput@defaultshadowcolor
    \let\xput@backcoveroptionshadowxshift\xput@defaultshadowxshift
    \let\xput@backcoveroptionshadowyshift\xput@defaultshadowyshift

    \ifdefined\xput@currentcontents
      \let\xput@backcovercontent\xput@currentcontents
      \def\xput@backcovertemplate{#2}
    \else
      \def\xput@backcovercontent{#2}
    \fi
  \fi
}
\newcommand\xput@frontcover[2][]{
  \xput@ispagetrue
  \xput@hascovertrue
  \xput@setupcover
  \setcounter{page}{0}
  \global\xput@topmargintmp=\topmargin\global\topmargin=\xput@undefdim
  \ifxput@cover
    \global\xput@frontcovertrue
    \xput@setdimensions
    \begin{picture}(\xput@dimentonumber\paperwidth,\xput@dimentonumber\paperheight)
      \topmargin=\xput@topmargintmp
      \global\xput@backcovertrue
      \def\xput@currentbeforepage{}
      \begingroup
        \ifdefined\xput@backcovercontent
          \xput@applybackcoveroptions
          \xput@putbeforepage
          \ifdefined\xput@backcovertemplate
            \xput@placeholdercounter 0\relax%
            \let\xput@currentcontents\xput@backcovercontent%
            \xput@backcovertemplate%
          \else
            \xput@backcovercontent
          \fi
        \fi
        \xput@putbleed
        \xput@putgrid
        \xput@putcuttingmarks
        \xput@putsafezone
      \endgroup
      \global\xput@backcoverfalse
      \xput@resetautogrid
      \xput@gridoffsetx=\dimexpr(\xput@pagewidth + \xput@outerbleed - \xput@innerbleed + \spinewidth)\relax
      \xput@applypageoptions{#1}
      \global\xput@placeholdercounter=0\relax
      \xput@putbeforepage
      #2
      \xput@putbleed
      \xput@putgrid
      \xput@putcuttingmarks
      \xput@putsafezone
    \end{picture}
    \global\xput@frontcoverfalse
    \let\xput@backcovercontent\undefined
  \else
    \xput@setdimensions
    \begin{picture}(\xput@dimentonumber\paperwidth,\xput@dimentonumber\paperheight)
      \topmargin=\xput@topmargintmp
      \xput@applypageoptions{#1}
      \def\xput@currentbeforepage{}
      \xput@putbeforepage
      #2
      \xput@putbleed
      \xput@putgrid
      \xput@putcuttingmarks
      \xput@putsafezone
    \end{picture}
  \fi
  \global\topmargin=\xput@topmargintmp
  \xput@ispagefalse
}
\newcommand\leftpage[1]{
  \ifxput@leftpage
    \xput@renderleftpage{#1}
  \else
    \ifxput@fanfold
      \ifxput@isdoublepage
        \xput@renderleftpage{#1}
      \fi
    \else
      \ifxput@isdoublepage
        \xput@renderleftpage[1]{#1}
      \fi
    \fi
  \fi
}
\newcommand\rightpage[1]{
  \ifxput@rightpage
    \xput@renderrightpage{#1}
  \else
    \ifxput@fanfold
      \ifxput@isdoublepage
        \xput@renderrightpage{#1}
      \fi
    \else
      \ifxput@isdoublepage
        \xput@renderrightpage[1]{#1}
      \fi
    \fi
  \fi
}
\newcommand\xput@renderleftpage[2][0]{
  \begingroup
    \xput@isdoublepagefalse
    \xput@setdimensions
    \xput@closerows
    \ifnum#1=1
      \xput@drymodetrue
    \fi
      #2
    \ifnum#1=1
      \xput@drymodefalse
    \else
      \ifxput@isbeforepage
      \else
        \xput@putgrid
      \fi
    \fi
  \endgroup
}
\newif\ifxput@wasdoublepage
\newif\ifxput@renderrightpage
\newcommand\xput@renderrightpage[2][0]{
  \xput@renderrightpagetrue
  \begingroup
    \ifxput@fanfold
      \ifxput@isdoublepage
        \xput@wasdoublepagetrue
        \addtocounter{page}{1}
      \fi
    \fi
    \xput@isdoublepagefalse
    \xput@rightpagetrue
    \xput@leftpagefalse
    \xput@setdimensions
    \xput@closerows
    \ifnum#1=1
      \xput@drymodetrue
    \fi
      #2
    \ifnum#1=1
      \xput@drymodefalse
    \else
      \ifxput@isbeforepage
      \else
        \xput@putgrid
      \fi
    \fi
    \ifxput@fanfold
      \ifxput@wasdoublepage
        \xput@wasdoublepagefalse
        \addtocounter{page}{-1}
      \fi
    \fi
  \endgroup
  \xput@renderrightpagefalse
}

% templates
\newif\ifxput@drymode
\newif\ifxput@placeholderoptions
\newif\ifxput@placeholdermode
\newif\ifxput@isplace
\xput@placeholderoptionstrue
\newcount\xput@placeholdercounter
\newcount\xput@contentcounter
\newdimen\xput@placeholderfontsize
\def\xput@frameyymax{0}
\def\xput@framexxmax{0}
\def\xput@setgridframe#1 #2 #3 #4 \\{
  \def\xput@framey{#1}
  \def\xput@framex{#2}
  \def\xput@frameyy{#3}
  \def\xput@framexx{#4}
}
\def\xput@setdefaultgridframe#1 #2 #3 #4 \\{
  \def\xput@defaultframey{#1}
  \def\xput@defaultframex{#2}
  \def\xput@defaultframeyy{#3}
  \def\xput@defaultframexx{#4}
  \xput@setgridframe #1 #2 #3 #4 \\
}
\def\xput@resetgridframe{
  \global\xput@isplacefalse
  \pgfmathceil{\xput@frameyy}
  \pgfmathint{\pgfmathresult}
  \global\edef\xput@currentrow{\pgfmathresult}
  \ifnum\xput@currentrow>\xput@frameyymax
    \global\edef\xput@frameyymax{\xput@currentrow}
    \global\def\xput@framexxmax{0}
  \fi
  \pgfmathceil{\xput@framexx}
  \pgfmathint{\pgfmathresult}
  \global\edef\xput@currentcell{\pgfmathresult}
  \ifnum\xput@currentcell>\xput@framexxmax
    \global\edef\xput@framexxmax{\xput@currentcell}
  \fi

  \pgfmathqparse{\xput@get{\xput@frameyymax C}pt>\xput@framexxmax pt}
  \ifnum\pgfmathresult=1
    \global\edef\xput@framey{\the\numexpr\xput@frameyymax-1\relax}
    \global\edef\xput@framex{\xput@framexxmax}
    \global\edef\xput@frameyy{\xput@frameyymax}
    \global\edef\xput@framexx{\the\numexpr\xput@framexxmax+1\relax}
  \else
    \ifnum\xput@frameyymax=\xput@rowscount
      \global\xput@gridfulltrue
    \else
      \global\edef\xput@framey{\xput@frameyymax}
      \global\edef\xput@framex{0}
      \global\edef\xput@frameyy{\the\numexpr\xput@frameyymax+1\relax}
      \global\edef\xput@framexx{1}
    \fi
  \fi
}
\newcommand\placeholder[2][0]{
  \begingroup
  \ifx#2\xput@emptystring
  \else
    \global\xput@isplacetrue
  \fi
  \def\xput@currentplaceholder{}
  \ifnum#1=0
    \global\advance \xput@placeholdercounter by 1
  \else
    \global\xput@placeholdercounter=#1
  \fi
  \xput@contentcounter 0\relax
  \def\xput@tmp{\xput@currentcontents}
  \xput@placeholdermode{1}
  \xput@tmp
  \xput@placeholdermode{0}
  \xput@putcontent{
    \ifx\xput@emptystring\xput@currentplaceholder
      \ifxput@placeholder
        \ifx#2\xput@emptystring
        \else
          \xput@setgridframe #2 \\
        \fi
        \xput@textboxheight=\dimexpr(\posy{1}{\xput@framey} - \posy{-1}{\xput@frameyy})\relax
        \xput@textboxwidth=\dimexpr(\posx{-1}{\xput@frameyy}{-1}{\xput@framexx} - \posx{1}{\xput@framey}{1}{\xput@framex})\relax
        \ifdim\xput@textboxwidth>\xput@textboxheight
          \xput@placeholderfontsize=0.5\xput@textboxheight
        \else
          \xput@placeholderfontsize=0.5\xput@textboxwidth
        \fi
        \ifdim\xput@placeholderfontsize>1000pt
          \xput@placeholderfontsize=1000pt
        \fi
        \xput@putxput{\xput@framey}{\xput@framex}{\xput@frameyy}{\xput@framexx}{%
          \begin{tikzpicture}%
            \pgflowlevelsynccm%
            \filldraw[line width=0.1mm,draw=cyan!60,fill=cyan!30,opacity=0.3] (0,0) rectangle ++(\width,\height);
            \ifdim\xput@placeholderfontsize>5mm
              \node[opacity=0.3] at (0.5\width,0.5\height){
                \fontsize{\xput@placeholderfontsize}{0pt}\selectfont\textcolor{cyan!60}{\textbf{\the\xput@placeholdercounter}}
              };
            \fi
          \end{tikzpicture}%
        }
        \xput@resetgridframe
      \else
        \ifx\xput@currentplaceholdertype\xput@placeholdertypeusetext
          \ifx#2\xput@emptystring
          \else
            \xput@setgridframe #2 \\
          \fi
          \ifx\xput@currentplaceholderoptions\xput@emptystring
            \xput@placeholderoptionsfalse
            \csname \xput@currentplaceholdertype\endcsname
            \xput@placeholderoptionstrue
          \else
            \csname \xput@currentplaceholdertype\endcsname[\xput@currentplaceholderoptions]
          \fi
        \fi
      \fi
    \else
      \ifx#2\xput@emptystring
      \else
        \xput@setgridframe #2 \\
      \fi
      \ifx\xput@currentplaceholderoptions\xput@emptystring
        \xput@placeholderoptionsfalse
        \csname \xput@currentplaceholdertype\endcsname{\xput@currentplaceholder}
        \xput@placeholderoptionstrue
      \else
        \csname \xput@currentplaceholdertype\endcsname[\xput@currentplaceholderoptions]{\xput@currentplaceholder}
      \fi
    \fi
  }
  \endgroup
}
\newcommand\xput@graphic[2][]{
  \advance \xput@contentcounter by 1
  \ifnum\xput@contentcounter=\xput@placeholdercounter
    \def\xput@currentplaceholdertype{graphic}
    \def\xput@currentplaceholderoptions{}
    \pgfkeys{graphic,file={#2},scale=1,vpos=0.5,hpos=0.5,unsharp=\xput@unsharp,#1}
    \ifcsname xput@graphic@#2\endcsname%
      \csname xput@graphic@#2\endcsname[2]{#1}%
    \fi

    \edef\xput@currentplaceholder{\xput@graphicoptionfile}
  \fi
}
\newcommand\xput@xput[1]{
  \advance \xput@contentcounter by 1
  \ifnum\xput@contentcounter=\xput@placeholdercounter
    \def\xput@currentplaceholdertype{xput}
    \def\xput@currentplaceholderoptions{}
    \def\xput@currentplaceholder{#1}
  \fi
}
\newcommand\xput@tikz[1]{
  \advance \xput@contentcounter by 1
  \ifnum\xput@contentcounter=\xput@placeholdercounter
    \def\xput@currentplaceholdertype{tikzgraphic}
    \def\xput@currentplaceholderoptions{}
    \def\xput@currentplaceholder{#1}
  \fi
}
\newcommand\xput@text[2][]{
  \advance \xput@contentcounter by 1
  \ifnum\xput@contentcounter=\xput@placeholdercounter
    \def\xput@currentplaceholdertype{text}
    \def\xput@currentplaceholderoptions{}
    \edef\xput@currentborderradius{\xput@defaultborderradius}
    \edef\xput@currentborderwidth{\xput@defaultborderwidth}
    \edef\xput@currentbordercolor{\xput@defaultbordercolor}
    \edef\xput@currentborderopacity{\xput@defaultborderopacity}
    \pgfkeys{text,name=default,color=\ifx\xput@pageoptioncolor\xput@emptystring\xputoptions@color\else\xput@pageoptioncolor\fi,border radius=\xput@currentborderradius,border width=\xput@currentborderwidth,border color=\xput@currentbordercolor,border opacity=\xput@currentborderopacity,#1}
    \def\xput@currentplaceholder{#2}
  \fi
}
\def\xput@placeholdertypeusetext{usetext}
\newcommand\xput@usetext[1][default]{
  \advance \xput@contentcounter by 1
  \ifnum\xput@contentcounter=\xput@placeholdercounter
    \edef\xput@currentplaceholdertype{\xput@placeholdertypeusetext}
    \def\xput@currentplaceholderoptions{#1}
    \def\xput@currentplaceholder{}
  \fi
}
\newcommand\xput@rendertemplate[3]{
  \xput@placeholdercounter 0\relax%
  \global\def\xput@currentcontents{#2}%
  \page[#1]{%
    #3
  }%
}
\newcommand{\newtemplate}[3][]{
  \expandafter\newcommand\csname xput@template@#2\endcsname[2][]{%
    \xput@rendertemplate{#1,##1}{##2}{#3}
  }%
}
\newcommand\template[3][]{
  \ifcsname xput@template@#2\endcsname%
  \else%
    \newtemplate[]{#2}{
      \xput@gridsc{#2}
    }
  \fi
  \csname xput@template@#2\endcsname[#1]{
    #3
  }
}
\newcommand\graphic{}
\newcommand\xput{}
\newcommand\tikzgraphic{}
\newcommand\usetext{}
\newcommand\text{}
\newcommand\xput@putcontent[1]{
  \ifxput@drymode
  \else
    \begingroup
    \ifxput@gridfull
      \ifxput@isplace#1\fi
    \else
      #1
    \fi
    \endgroup
  \fi
}
\newcommand\xput@placeholdermode[1]{
  \xput@placeholdermodefalse
  \ifnum#1=0%
    \renewcommand\graphic[2][]{%
      \xput@putcontent{%
        \def\xput@graphicoptionfile{##2}
        \ifxput@placeholderoptions
          \ifcsname xput@graphic@##2\endcsname%
            \csname xput@graphic@##2\endcsname[2]{##1}
          \else
            \pgfkeys{graphic,file={##2},scale=1,vpos=0.5,hpos=0.5,unsharp=\xput@unsharp,##1}
          \fi
        \fi
        \xput@putgraphic{\xput@framey}{\xput@framex}{\xput@frameyy}{\xput@framexx}{\xput@graphicoptionfile}%
        \xput@resetgridframe
      }
    }%
    \renewcommand\xput[1]{%
      \xput@putcontent{%
        \xput@putxput{\xput@framey}{\xput@framex}{\xput@frameyy}{\xput@framexx}{##1}%
        \xput@resetgridframe
      }
    }%
    \renewcommand\tikzgraphic[1]{%
      \xput@putcontent{%
        \xput@puttikz{\xput@framey}{\xput@framex}{\xput@frameyy}{\xput@framexx}{##1}%
        \xput@resetgridframe
      }
    }%
    \renewcommand\usetext[1][default]{%
      \xput@putcontent{%
        \xput@putusetext[##1]{\xput@framey}{\xput@framex}{\xput@frameyy}{\xput@framexx}%
        \xput@resetgridframe
      }
    }%
    \renewcommand\text[2][]{%
      \xput@putcontent{%
        \edef\xput@currentborderradius{\xput@defaultborderradius}
        \edef\xput@currentborderwidth{\xput@defaultborderwidth}
        \edef\xput@currentbordercolor{\xput@defaultbordercolor}
        \edef\xput@currentborderopacity{\xput@defaultborderopacity}
        \pgfkeys{text,name=default,color=\ifx\xput@pageoptioncolor\xput@emptystring\xputoptions@color\else\xput@pageoptioncolor\fi,border radius=\xput@currentborderradius,border width=\xput@currentborderwidth,border color=\xput@currentbordercolor,border opacity=\xput@currentborderopacity,##1}
        \xput@puttext{\xput@framey}{\xput@framex}{\xput@frameyy}{\xput@framexx}{##2}%
        \xput@resetgridframe
      }
    }%
  \else%
    \xput@placeholdermodetrue
    \renewcommand\graphic[2][]{%
      \xput@graphic[##1]{##2}%
    }%
    \renewcommand\xput[1]{%
      \xput@xput{##1}%
    }%
    \renewcommand\tikzgraphic[1]{%
      \xput@tikz{##1}%
    }%
    \renewcommand\usetext[1][default]{%
      \xput@usetext[##1]%
    }
    \renewcommand\text[2][]{%
      \xput@text[##1]{##2}%
    }
  \fi%
}
\xput@placeholdermode{0}
\newcommand\place[1]{
  \xput@isplacetrue
  \xput@setgridframe #1 \\
}
\xput@setdefaultgridframe 0 0 1 1 \\

\newcommand\xput@emptypage{
  \global\xput@isemptypagetrue
  \page[before page=,page graphic=,page color=]{}
  \global\xput@isemptypagefalse
}

\def\xput@tocfixpageoffset{0}
\def\sectioncalled{
  \ifxput@fanfold
    \ifxput@isdoublepage
      \ifxput@rightpage
        \global\def\xput@tocfixpageoffset{1}
      \fi
    \else
      \ifxput@renderrightpage
        \global\def\xput@tocfixpageoffset{1}
      \else
        \ifxput@leftpage
          \global\def\xput@tocfixpageoffset{-1}
        \fi
      \fi
    \fi
  \fi
}

\def\xput@turbojobname{xputturbobatchoptimizexyz}
\edef\xput@turbojobname{\meaning\xput@turbojobname}
\edef\xput@jobname{\jobname}
\edef\xput@jobname{\meaning\xput@jobname}
\AtBeginDocument{
  % fanfold toc partial fix
  \let\xput@originalsection\section
  \def\xput@nextsection#1{
    \sectioncalled
    \@ifnextchar\bgroup{\xput@originalsection*}{\xput@originalsection{#1}}}
  \let\section\xput@nextsection
  \let\xput@originalsubsection\subsection
  \def\xput@nextsubsection#1{
    \sectioncalled
    \@ifnextchar\bgroup{\xput@originalsubsection*}{\xput@originalsubsection{#1}}}
  \let\subsection\xput@nextsubsection

  \ifxput@optimize
  \else
    \xput@isturbomodefalse
  \fi

  \ifxput@isturbomode
    \ifx\xput@jobname\xput@turbojobname
      \xput@placeholderfalse
      \xput@gridfalse
      \xput@safezonefalse
      \xput@cuttingmarksfalse
      \xput@fillpagesfalse
      \xput@graphpaperfalse
      \xput@preflightfalse

      \xput@isbatchmodetrue
    \else
      \xput@start
    \fi
  \else
    \ifxput@import
      \xput@start
    \fi
  \fi

  \ifx\xput@pagegraphic\xput@emptystring
    \ifx\xputoptions@pagegraphic\xput@emptystring
    \else
      \setpagegraphic{\xputoptions@pagegraphic}
    \fi
  \fi

  \ifxput@fanfold
    \xput@covertrue
  \fi
}
\AtEndDocument{
  \ifxput@beginleft
    \ifxput@leftpage
      \xput@hasoddnumberofpagestrue
    \fi
  \else
    \ifxput@rightpage
      \xput@hasoddnumberofpagestrue
    \fi
  \fi
  \ifdefined\xput@backcovercontent
    \xput@haspagestrue
    \ifxput@haslastemptypage
      \ifxput@hasoddnumberofpages
        \xput@standardpage[before page=]{}
        \xput@emptypage
      \else
        \xput@emptypage
      \fi
    \else
      \ifxput@twoside
        \ifxput@hasoddnumberofpages\page[before page=]{}\fi
      \fi
    \fi
    \xput@leftpagetrue
    \xput@rightpagefalse
    \xput@backcovertrue
    \ifdefined\xput@backcovertemplate
      \xput@placeholdercounter 0\relax%
      \let\xput@currentcontents\xput@backcovercontent%
      \def\xput@currentbeforepage{}
      \xput@standardpage{%
        \xput@backcovertemplate%
      }%
    \else
      \def\xput@currentbeforepage{}
      \xput@standardpage{
        \xput@backcovercontent
      }
    \fi
  \else
    \ifxput@haspages
      \ifxput@fanfold
        \ifxput@isfanfoldopen
          \ifxput@beginleft
            \xput@standardpage[before page=]{}
          \else
            \xput@emptypage
          \fi
        \else
          \ifxput@beginleft
          \else
            \xput@standardpage[before page=]{}
            \xput@emptypage
          \fi
        \fi
      \else
        \ifxput@haslastemptypage
          \ifxput@hasoddnumberofpages
            \xput@standardpage[before page=]{}
            \xput@emptypage
          \else
            \xput@emptypage
          \fi
        \else
          \ifxput@twoside
            \ifxput@hasoddnumberofpages\xput@standardpage[before page=]{}\fi
          \fi
        \fi
      \fi
    \fi
  \fi
  \ifxput@isbatchmode
    \xput@batchoptimize
  \fi
}

% scripts
\newread\xput@scriptresult
\def\xput@batchlist{}
\def\xput@ok{ok}
\def\xput@err@shellaccessforbidden{errorshellaccessforbidden}
\def\xput@err@importdirnotfound{errorimportdirnotfound}
\def\xput@err@noimportdir{errornoimportdir}
\def\xput@err@magicknotinstalled{errormagicknotinstalled}
\def\xput@err@inkscapenotinstalled{errorinkscapenotinstalled}
\newcommand\xput@getppi[1]{
  \immediate\openin\xput@scriptresult={|xputserver getwidth\% "#1"}
  \ifeof\xput@scriptresult
    \xput@errmsg@shellaccessforbidden{Ppi not calculated}
  \else
    \endlinechar=-1
    \read\xput@scriptresult to \xput@graphicwidth
    \endlinechar=13
    \ifx\xput@graphicwidth\xput@emptystring
      \xput@errmsg@shellaccessfailed{Ppi not calculated}
    \else
      \ifx\xput@graphicwidth\xput@err@magicknotinstalled
        \xput@errmsg@magicknotinstalled{Ppi not calculated}
      \else
        \pgfmathqparse{(\xput@originalgraphicwidth - \xput@cropleft - \xput@cropright) / \xput@originalgraphicwidth * \xput@graphicwidth pt / \the\width * 72.27pt}

        \pgfmathint{\pgfmathresult}
        \edef\xput@graphicdensity{\pgfmathresult}
      \fi
    \fi
  \fi
  \immediate\closein\xput@scriptresult
}
\newcommand\xput@optimizegraphic[2]{
  \immediate\openin\xput@scriptresult={|xputserver optimize\% "#1#2" \% "\xput@filename" \%\xput@optimizedext\%\the\numexpr\xput@originalgraphicwidth\%\the\numexpr\xput@originalgraphicheight\%\the\numexpr\xput@cropleft\%\the\numexpr\xput@cropright\%\the\numexpr\xput@croptop\%\the\numexpr\xput@cropbottom\%\the\numexpr\xput@density\%\the\numexpr\width\%\the\numexpr\height\%\xput@downsamplethreshold\%\xput@graphicoptionunsharp\%\xput@quality}
  \ifeof\xput@scriptresult
    \xput@errmsg@shellaccessforbidden{File not optimized}
  \else
    \endlinechar=-1
    \read\xput@scriptresult to \xput@processresult
    \endlinechar=13
    \ifx\xput@processresult\xput@emptystring
      \xput@errmsg@shellaccessfailed{File not optimized}
    \else
      \ifx\xput@processresult\xput@err@magicknotinstalled
        \xput@errmsg@magicknotinstalled{File not optimized}
      \fi
    \fi
  \fi
  \immediate\closein\xput@scriptresult
}
\newcommand\xput@makeshadow[1]{
  \immediate\openin\xput@scriptresult={|xputserver makeshadow\%#1\%\xput@defaultshadowsize\%\xput@defaultshadowopacity\%\xput@defaultshadowcolor\%\the\xput@frameshadowwidth\%\the\xput@frameshadowheight\%\the\xput@frameshadowframewidth\%\the\xput@frameshadowframeheight\%\the\xput@frameshadowborder\%\the\xput@frameshadowradius}
  \ifeof\xput@scriptresult
    \edef\xput@processresult{\xput@err@shellaccessforbidden}
    \xput@errmsg@shellaccessforbidden{Shadow not created}
  \else
    \endlinechar=-1
    \read\xput@scriptresult to \xput@processresult
    \endlinechar=13
    \ifx\xput@processresult\xput@emptystring
      \xput@errmsg@shellaccessfailed{Shadow not created}
    \else
      \ifx\xput@processresult\xput@err@inkscapenotinstalled
        \xput@errmsg@inkscapenotinstalled{Shadow not created}
      \else
      \fi
    \fi
  \fi
  \immediate\closein\xput@scriptresult
}
\def\xput@start{
  \immediate\openin\xput@scriptresult={|xputserver start\ifxput@import\%import\% "\ifdefined\Ginput@path\Ginput@path\fi" \fi\ifxput@isturbomode\%turbo\% "\jobname" \fi}
  \ifeof\xput@scriptresult
    \ifxput@import
      \xput@errmsg@shellaccessforbidden{Import not working}
    \fi
  \else
    \endlinechar=-1
    \read\xput@scriptresult to \xput@processresult
    \endlinechar=13
    \ifx\xput@processresult\xput@emptystring
      \ifxput@import
        \xput@errmsg@shellaccessfailed{Import not working}
      \fi
    \else
      \ifx\xput@processresult\xput@ok
      \else
        \ifx\xput@processresult\xput@err@noimportdir
          \xput@errmsg@noimportdir
        \else
          \xput@errmsg@importdirnotfound{\xput@processresult}
        \fi
      \fi
    \fi
  \fi
  \immediate\closein\xput@scriptresult
}
\newcommand\xput@addtobatchlist[2]{
  \global\edef\xput@batchlist{\xput@batchlist\% "#1#2" \% "\xput@filename" \%\xput@optimizedext\%\the\numexpr\xput@originalgraphicwidth\%\the\numexpr\xput@originalgraphicheight\%\the\numexpr\xput@cropleft\%\the\numexpr\xput@cropright\%\the\numexpr\xput@croptop\%\the\numexpr\xput@cropbottom\%\the\numexpr\xput@density\%\the\numexpr\width\%\the\numexpr\height\%\xput@downsamplethreshold\%\xput@graphicoptionunsharp\%\xput@quality}
}
\newcommand\xput@batchoptimize{
  \immediate\openin\xput@scriptresult={|xputserver batchoptimize\xput@batchlist}
  \ifeof\xput@scriptresult
  \else
    \endlinechar=-1
    \read\xput@scriptresult to \xput@processresult
    \endlinechar=13
  \fi
  \immediate\closein\xput@scriptresult
}

% errors
\def\xput@errmsg@undefined#1#2{
  \ifx#2\xput@emptystring
  \else
    \ClassError{Xput}{Undefined #1 `#2'}{Check the name `#2'.\MessageBreak\MessageBreak\@ehc}
  \fi
}
\def\xput@errmsg@backcoverdefinedafterfrontcover{
  \ClassError{Xput}{Back cover needs to be defined before front cover}{Define the back cover before the front cover.\MessageBreak\MessageBreak\@ehc}
}
\def\xput@errmsg@shellaccessforbidden#1{
  \ClassError{Xput}{Shell access forbidden. #1}{Make sure `xputserver' is added to the list of shell escape commands\MessageBreak(shell_escape_commands = xputserver) in your `texmf.cnf'.\MessageBreak\MessageBreak\@ehc}
}
\def\xput@errmsg@shellaccessfailed#1{
  \ifdefined\XeTeXversion
    \ClassError{Xput}{Shell access failed. #1}{Make sure the xput `scripts' folder is added to your path.\MessageBreak\MessageBreak\@ehc}
  \else
    \ClassError{Xput}{Shell access failed. #1}{Make sure the xput `scripts' folder is added to your path.\MessageBreak Shell access does not work in unrestricted mode (--shell-escape).\MessageBreak Make sure `xputserver' is added to the list of shell escape commands\MessageBreak(shell_escape_commands = xputserver) in your `texmf.cnf'.\MessageBreak\MessageBreak\@ehc}
  \fi
}
\def\xput@errmsg@inkscapenotinstalled#1{
  \ClassError{Xput}{Inkscape not installed. #1}{Make sure Inkscape is installed.\MessageBreak\MessageBreak\@ehc}
}
\def\xput@errmsg@magicknotinstalled#1{
  \ClassError{Xput}{ImageMagick not installed. #1}{Make sure ImageMagick is installed.\MessageBreak\MessageBreak\@ehc}
}
\def\xput@errmsg@importdirnotfound#1{
  \ClassError{Xput}{Import directory `#1' not found}{Create the directory `#1'.\MessageBreak\MessageBreak\@ehc}
}
\def\xput@errmsg@noimportdir{
  \ClassError{Xput}{Import directory not found}{Create the directory `import' in your working directory\MessageBreak or define the shell variable `XPUT_IMPORT_DIRECTORY'.\MessageBreak\MessageBreak\@ehc}
}
\def\xput@errmsg@lowdensity#1#2#3{
  \ifnum#1=0
    \ClassWarning{Xput}{The file `#2' has a low pixel density of #3 ppi}
  \else
    \ClassError{Xput}{The file `#2' has a very low a pixel density of #3 ppi}{Replace the image with one of higher resolution or reduce the display size.\MessageBreak\MessageBreak\@ehc}
  \fi
}
