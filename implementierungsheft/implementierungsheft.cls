\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{entwurfsheft}[2023/06/17 LaTeX class for the entwurfsheft]
\LoadClass[parskip=full]{scrartcl}
\RequirePackage[top=2.54cm, bottom=2.54cm, left=2.54cm, right=2.54cm]{geometry}
\RequirePackage[utf8]{inputenc} % use utf8 file encoding for TeX sources
\RequirePackage[T1]{fontenc}    % avoid garbled Unicode text in pdf
\RequirePackage{lmodern}
\RequirePackage[ngerman]{babel}  % german hyphenation, quotes, etc
\RequirePackage{hyperref}       % hyperlinks in document
\RequirePackage{glossaries}     % glossary 
\RequirePackage{enumerate}      % advanced enumeration
\RequirePackage[shortlabels]{enumitem}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{caption}        % add captions
\RequirePackage{adjustbox}      % add adjustmentbox
\RequirePackage{csquotes}
\RequirePackage{multicol}
\RequirePackage{microtype}
 
% Set footer and header bar
\RequirePackage[headsepline, footsepline]{scrlayer-scrpage}
\addtokomafont{headsepline}{\color{BlueViolet}}
\addtokomafont{footsepline}{\color{BlueViolet}}
\KOMAoptions{headsepline=1.25pt:\textwidth}
\KOMAoptions{footsepline=1.25pt:\textwidth}
\clearpairofpagestyles
\rofoot{\thepage}
\ihead{Write your own Android App: SpiceSquad}

% set the hyperlink style in the document
\hypersetup{
    pdftitle={PSE: Entwurfsheft},
    pdfborderstyle={/S/U/W 1},
    colorlinks,
    linkcolor={black!50!black},
    citecolor={blue!50!black},
    urlcolor={blue!80!black}
}

% sets right quotation for "
\MakeOuterQuote{"}

%change figure numbering
\renewcommand{\thefigure}{\thesection.\arabic{figure}}

%add command to hide subsections from toc
\newcommand{\changelocaltocdepth}[1]{%
  \addtocontents{toc}{\protect\setcounter{tocdepth}{#1}}%
  \setcounter{tocdepth}{#1}%
}

\newcommand{\enablesubsectionnumbering}[1]{
    \renewcommand{\thesubsection}{$\langle$#1\arabic{subsection}0$\rangle$}
    \changelocaltocdepth{1} 
}

\newcommand{\resetsubsectionnumbering}{
    \renewcommand{\thesubsection}{\arabic{section}.\arabic{subsection}}
    \changelocaltocdepth{3} 
}
\renewcommand{\glossarysection}[2][]{}
\renewcommand{\maketitle}{
    \begin{titlepage}
        \begin{center}
            \begin{Huge}
                {\textbf{Write your own Android App: SpiceSquad}}
            \end{Huge}
            \vspace{12px}
    
            Praxis der Softwareentwicklung (PSE)\\
            Sommersemester 2023\\
            \vspace{150px}
    
            \begin{Huge}
                {\textbf{Implementierungsheft}}
            \end{Huge}
            \vspace{12px}
    
            \textbf{Auftraggeber}\\
            Karlsruher Institut für Technologie\\
            KASTEL — Institut für Informationssicherheit und Verlässlichkeit\\
            \vspace{330px}
    
            \textbf{Auftragnehmer}\\
            Karlsruher Intellektuelle\\
            Henri Becker, Konrad Knappe, Lukas Schwarz, Raphael Zipperer\\
        \end{center}
    \end{titlepage}
}
\counterwithin{figure}{section}
