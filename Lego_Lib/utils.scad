function isTransparent(prmColor) = (prmColor[0]=="_" || prmColor[0]=="+") ? true : false;
function getTransparency(prmColor) = prmColor[0]=="_" ? 0.5 : prmColor[0]=="+" ? 0.75 : 1.0;
function removeTranparencyChar(prmColor) = isTransparent(prmColor) ? chr([for(i=[1:len(prmColor)-1]) ord(prmColor[i])]) : prmColor;


module colorEx(prmColor) 
{       
    color(removeTranparencyChar(prmColor),getTransparency(prmColor)) 
    { 
        children(); 
    }
}    


module importEx(prmFSpec)
{
    echo(prmFSpec);
    import(prmFSpec);
}
