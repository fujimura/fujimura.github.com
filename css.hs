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
    background white
    fontSize (px 16)
    fontFamily ["Arial", "sans-serif"] []
    sym2 margin 50 auto
    maxWidth (em 50)
    textAlign (alignSide sideCenter)

theContents :: Css
theContents = do
    position relative
    backgroundImage $ url "otaru.jpg"
    sym2 margin 0 auto
    width $ px 612
    height $ px 612
    boxShadow (px 5) (px 5) (px 5) gray

theMainHeader :: Css
theMainHeader = do
    position absolute
    color $ rgb 27 27 39
    top   $ px 100
    left  $ px 60
    fontSize $ px 26
    fontFamily ["Georgia", "Serif"] []
    fontWeight normal
    letterSpacing $ px 2

theMainHeaderDescription :: Css
theMainHeaderDescription = do
   position absolute
   color $ rgb 27 27 39
   fontFamily ["Georgia", "Serif"] []
   fontSize $ px 16
   top  $ px 365
   left $ px 80

theMenu :: Css
theMenu = do
    "list-style" -: "none outside"
    fontFamily ["Georgia", "Serif"] []
    fontSize $ px 14
    position absolute
    width $ px 200
    top  $ px 397
    left $ px 390
    transform (rotateX $ deg 2)

theMenuItem :: Css
theMenuItem = do
    sym padding $ px 2
    a # visited ? color (rgb 27 27 39)
    a # hover   ? color (rgb 73 119 165)
