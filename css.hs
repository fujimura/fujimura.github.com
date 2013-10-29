{-# LANGUAGE OverloadedStrings #-}
import Clay

main = putCss $ do
    body ? theBody
    "#contents"                ? theContents
    ".main-header"             ? theMainHeader
    ".main-header-description" ? theMainHeaderDescription
    ".menu"                    ? theMenu
    ".menu-item"               ? theMenuItem

theBody :: Css
theBody = do
    sansSerifFont

    background white
    fontSize (px 16)
    sym2 margin 50 auto
    maxWidth (em 50)
    textAlign (alignSide sideCenter)

theContents :: Css
theContents = do
    position relative
    backgroundImage $ url "http://fujimuradaisuke.s3-ap-northeast-1.amazonaws.com/otaru.jpg"
    sym2 margin 0 auto
    width $ px 612
    height $ px 612
    boxShadow (px 5) (px 5) (px 5) gray

theMainHeader :: Css
theMainHeader = do
    placel (px 100) (px 60)
    serifFont
    color $ rgb 27 27 39
    fontSize $ px 26
    fontWeight normal
    letterSpacing $ px 2

theMainHeaderDescription :: Css
theMainHeaderDescription = do
   placel (px 365) (px 80)
   serifFont
   color $ rgb 27 27 39
   fontSize $ px 16

theMenu :: Css
theMenu = do
    "list-style" -: "none outside"
    placel (px 397) (px 390)
    serifFont
    fontSize $ px 14
    width $ px 200
    {-transform (rotateX $ deg 2)-}

theMenuItem :: Css
theMenuItem = do
    sym padding $ px 2
    a # visited ? color (rgb 27 27 39)
    a # hover   ? color (rgb 73 119 165)

placel :: Size Abs -> Size Abs -> Css
placel t l = do
    position absolute
    top  t
    left l

-- Typography

serifFont :: Css
serifFont = fontFamily ["Georgia", "Serif"] []

sansSerifFont :: Css
sansSerifFont = fontFamily ["Arial", "sans-serif"] []
