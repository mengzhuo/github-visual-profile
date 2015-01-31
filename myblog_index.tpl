<!DOCTYPE html>
<html lang="zh">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width" />
        <meta name="generator" content="Github Profiler 0.1-beta">
        <meta name="time" content="$generate_time">
        <title>蒙卓</title>
        <style type="text/css">
            body {padding:0;margin:0;text-align:right;min-width:970px;}

            text {font-family:"Helvetica Neue", Helvetica, Arial, sans-serif;}
            #content {top:0;float:left;position:fixed;min-width:10em;border-right:1px solid #ccc;padding:1em;}
            #content hr {color:#ccc;}
            #content a, #content a:visited{text-decoration:none;color:rgb(49,130,189)}
            a:hover{
                    filter: url(#drop-shadow);
                   }
            
        </style>
        <script type="text/javascript" charset="utf-8">
        var profile = $data;
        </script>
        <script src="/js/d3.v3.min.js" type="text/javascript" charset="utf-8"></script>
        <script>
        window.onload = function(){
        w = window.innerWidth
        h = window.innerHeight - 20
        diameter = Math.min(w, h),
            colorGen = d3.scale.category20c(); 
        svg = d3.select("div#vis").append('svg')
                    .attr("width", w-80)
                    .attr("height", h)
                    .style("top",0)
                    .style("float", "left")

        console.log("svg", svg);
        bubble = d3.layout.pack()
                       .size([w,h])
                       .value(function(d) {return d.size;})
                       .padding(5);
        language_group = {};

        function processData(data){

            var newSet = [];
            for (var i in data){
                repo = data[i]
                var language = (repo.language == null)?"Unknown":repo.language;
                newSet.push({name:repo.name, className:language, size: Math.max(repo.impact, 0),
                             url:repo.html_url})
                
                if (language_group[language] == undefined){
                    language_group[language] = 1;
                } else {
                    language_group[language] += 1;
                }
            }
            return {children: newSet};
          }
          dd = processData(profile); 
          ld = [];
          for (var l in language_group){
              ld.push({"lable":l, "value":language_group[l]});
          }
          ld = ld.sort(function(a,b){return b.value-a.value});
            
          var y = d3.scale.linear()
                    .domain([0, ld[0].value])
                    .range([36,h/2])
              x = d3.scale.ordinal()
                    .domain(d3.range(ld.length))
                    .rangeBands([0, ld.length])

          bar = svg.selectAll("g")
                        .data(ld)
                        .enter().append("g")
                        .attr("transform",function(d, i ){return "translate("+ (w-(x(i)+5)*24) +",0)" })
                        .attr("height", function(d){console.log(d);return y(d.value)+"px";})
                        .attr("width", "24px")
          rect = bar.append("rect")
                        .attr("height", 0)
                        .attr("width", "24px")
          rect.transition()
                 .duration(500)
                 .delay(300)
                 .attr("height", function(d){console.log(d);return y(d.value)+"px";})
                 .attr("fill", function(d){return colorGen(d.lable)})
          bar.append("text").attr("fill","#fff")
                    .text(function(d){return d.lable})
                    .attr("transform", "rotate(90)")
                    .attr("dy", "-0.3em")
                    .attr("dx", "0.3em")

          nodes = bubble.nodes(dd)
                    .filter(function(d){return !d.children});

          console.log("nodes", nodes)

          g = svg.selectAll("a").data(nodes).enter()
                   .append('a')
                   .attr("xlink:href", function(d){return d.url})
                    .attr("transform", function(d){return 'translate('+w/2+','+h/2+')';})

          g.transition()
                    .delay(function(d, i){return i*7;})
                    .duration(500) 
                    .attr("transform", function(d){return 'translate(' + d.x + ',' + d.y + ')';})

          g.append("svg:title")
                   .text(function(d){ return d.name;})
                                            

          cir = g.append("circle")
                    .attr('class', function(d) { return d.className; })
                     .attr("fill", "#fff")
                     .attr("r", 0)

           cir.transition()
          .delay(function(d, i){return i*7;})
             .attr('r', function(d) { return d.r; })
             .duration(800)
             .attr("fill", function(d) { return colorGen(d.className);})

                    
          g.append("text")
                    .attr("text-anchor", "middle")
                    .attr("dy", ".3em")
                    .attr("fill", "#fff")
                    .attr("style", function(d) {return "font-size:"+d.r/100+"em";})
                    .text(function(d) {return d.name.substring(0, d.r/3);});
            
            var defs = svg.append("defs");

        // create filter with id #drop-shadow
        // height=130% so that the shadow is not clipped
        var filter = defs.append("filter")
            .attr("id", "drop-shadow")
            .attr("height", "150%");

        // SourceAlpha refers to opacity of graphic that this filter will be applied to
        // convolve that with a Gaussian with standard deviation 3 and store result
        // in blur
        filter.append("feGaussianBlur")
            .attr("in", "SourceAlpha")
            .attr("stdDeviation", 3)
            .attr("result", "blur");

        // translate output of Gaussian blur to the right and downwards with 2px
        // store result in offsetBlur
        filter.append("feOffset")
            .attr("in", "blur")
            .attr("dx", 2)
            .attr("dy", 2)
            .attr("result", "offsetBlur");

        // overlay original SourceGraphic over translated blurred opacity by using
        // feMerge filter. Order of specifying inputs is important!
        var feMerge = filter.append("feMerge");

        feMerge.append("feMergeNode")
            .attr("in", "offsetBlur")
        feMerge.append("feMergeNode")
            .attr("in", "SourceGraphic");
        };
        </script>
    </head>
    <body>
        <div id="vis">
        </div>
        <div id="content"> <h1>蒙卓</h1>
            <p>程序员</p>
            <hr/>
            <p><a href="https://mengzhuo.org/blog/">博客</a></p>
            <p><a href="https://twitter.com/mengzhuo/">Twitter</a></p>
            <p><a href="https://github.com/mengzhuo/">Github</a></p>
        </div>
    </body>
</html>
