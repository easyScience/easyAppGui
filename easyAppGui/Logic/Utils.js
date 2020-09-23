function prettyXml(xml, tab = '    ')
{
    let formatted = ''
    let indent = ''

    xml.split(/>\s*</).forEach(function(node)
    {
        if (node.match( /^\/\w/ ))
            indent = indent.substring(tab.length)

        formatted += indent + '<' + node + '>\r\n'

        if (node.match( /^<?\w[^>]*[^\/]$/ ))
            indent += tab
    })

    return formatted.substring(1, formatted.length-3);
}

function prettyJson(json, tab = '    ')
{
    return JSON.stringify(json, null, tab.length)
}
