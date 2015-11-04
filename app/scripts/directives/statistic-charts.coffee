'use strict'

###*
 # @ngdoc directive
 # @name switchfitApp.directive:statisticCharts
 # @description
 # # statisticCharts
###
angular.module('switchfitApp')
  .directive 'statChart', [
    "$rootElement"
    "$window"
    "$timeout"
    "$sce"
    ($rootElement, $window, $timeout, $sce) ->
#      template: '<div></div>'
      restrict: 'EA'
      transclude: 'true'
      scope: {
        statChart: '='
        statData: '='
        statConfig: '='
        statSubData: '='
      }
      link: (scope, element, attrs) ->
        config =
          title: ""
          tooltips: true
          mouseover: ->

          mouseout: ->

          click: ->
        totalWidth = element[0].clientWidth
        totalHeight = element[0].clientHeight
        throw new Error("Please set height and width for the chart element") if totalHeight is 0 or totalWidth is 0

        chartContainer = element
        data = undefined
        subData = undefined
        chartType = undefined

        svgContainers = {}

        init = () ->
          prepareData()
          chartFunc = getChartFunction(chartType)
          svgContainers[chartType] = chartFunc()
          return

        prepareData = () ->
          data = scope.statData
          subData = scope.statSubData
          chartType = scope.statChart
          angular.extend config, scope.statConfig  if scope.statConfig
          return

        getChartFunction = (type) ->
          charts =
            week: weekChart
            water: waterChart
            fitnessMark: fitnessMarkChart
            cravingsHungerMood: cravingsHungerMoodChart
            cigarettesGlucose: cigarettesGlucoseChart

          charts[type]

        subDataHandler = () ->
          sortFunc = getLayersSortFunction(chartType)
          if sortFunc isnt undefined
            sortFunc(chartType, subData)

        getLayersSortFunction = (type) ->
          layersSortFunction =
            cravingsHungerMood: cravingsHungerMoodSort
            cigarettesGlucose: cigarettesGlucoseSort
          if layersSortFunction[type] isnt undefined
            layersSortFunction[type]

        # Week chart func
        weekChart = () ->
          margin =
            top: 0
            right: 0
            bottom: 0
            left: 0

          width = totalWidth - margin.left - margin.right
          height = totalHeight - margin.top - margin.bottom
          x = d3.scale.ordinal().rangeRoundBands([0,width], 0.3, 0)
          x2Values = []
          part = width / 7
          i = 0
          while i <= 7
            x2Values[i] = (part * i) / width
            i++

          y2Values = []
          y2Max = 10
          y2Margin = 2
          j = 0
          while j <= 40
            if y2Values[j - 1]?
              y2Values[j] = y2Values[j - 1] + 0.025
            else
              y2Values[0] = 0
            j++
          x2 = d3.scale.linear()
            .domain([0,1])
            .range([0,width])
          xAxis = d3.svg.axis()
            .scale(x2)
            .ticks(8)
            .tickValues(x2Values)
            .tickSize(-height, 0, 0)
            .tickFormat("")
          y = d3.scale.linear()
            .range([0,height])
          y2 = d3.scale.linear()
            .domain([0,1])
            .range([0,height * 2])
          yAxis = d3.svg.axis()
            .scale(y2)
            .orient("left")
            .ticks(24)
            .tickValues(y2Values)
            .tickSize(-width, 0, 0)
            .tickFormat("")
          tip = d3.tip()
            .attr('class', 'd3-tip tip-weight')
            .offset([-10, 0])
            .html((d) ->
              return "<span>" + d.weight + "</span>";
            )

          d3.select(chartContainer[0]).select("svg").remove()
          svg = d3.select(chartContainer[0])
            .append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .attr("class", "graph-week")
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
          y.domain [-y2Max,y2Max]
          x.domain data.map((d, i) ->
            return i
          )
          # grid
          svg.append("g")
            .attr("class", "y axis grid")
            .call yAxis
          svg.append("g")
            .attr("class", "x axis grid")
            .attr("transform", "translate(0," + height + ")")
            .call xAxis
          svg.call(tip);

          # zero line
          svg.append("rect")
          .attr("class", "zero-line")
          .attr("x", 0)
          .attr("y", (d, i) ->
            return height - y(0) - 1
          )
          .attr("width", width)
          .attr("height", 2)
          .style("fill", "#9CA2BA")

          # bars
          svg.selectAll(".bar")
            .data(data)
            .enter()
            .append("rect")
            .attr("class", (d) ->
              (if d.offset < 0 then "bar negative" else "bar positive")
            )
            .attr("y", (d) ->
              return height / 2 + y2Margin
            )
            .attr("x", (d, i) ->
              return x(i)
            )
            .attr("rx", 2)
            .attr("height", 0)
            .attr("width", x.rangeBand())
            .style("fill", (d) ->
              (if d.offset < 0 then "#AAB4CC" else "#747189")
            )
            .on('mouseover', (d) ->
              if d.weight > 0
                tip.show(d)
            )
            .on('mouseout', tip.hide)
            .transition()
            .duration(500)
            .attr("height", (d) ->
              if d.offset == 0 and d.active and d.weight > 0
                return 2
              offset = d.offset
              if offset < -y2Max / 2
                offset = -y2Max / 2
              else if offset > y2Max / 2
                offset = y2Max / 2
              h = 0
              if offset < 0
                h = height / 2 - Math.abs(y(offset)) - y2Margin
              else
                h = Math.abs(y(offset)) - height / 2 - y2Margin  if offset > 0
              if h < 0
                h = 0
              return h
            )
            .attr("y", (d) ->
              if d.offset == 0 and d.active and d.weight > 0
                return height / 2 - 1
              offset = d.offset
              offset = y2Max / 2 if d.offset > y2Max / 2
              if offset < 0
                return height / 2 + y2Margin
              else
                return height - Math.abs(y(offset))
            )

          return svg

        # Water chart func
        waterChart = () ->
          waterStartData = [0]
          waterData = [0]
          for date, waterIntake of data
            waterData.push(waterIntake)
            waterStartData.push(0)

          margin =
            top: 10
            right: 0
            bottom: 0
            left: -2

          width = totalWidth - margin.left - margin.right
          height = totalHeight - margin.top - margin.bottom
          x = d3.scale.linear().range([0,width])
          y = d3.scale.linear().range([height,0])
          area = d3.svg.area()
            .x((d, i) ->
                x(i)
              )
            .y0(height)
            .y1((d) ->
              y(d)
            )
            .interpolate("cardinal")
          line = d3.svg.line()
            .x((d, i) ->
                x(i)
              )
            .y((d) ->
              y(d)
            )
            .interpolate("cardinal")
          tip = d3.tip()
            .attr('class', 'd3-tip tip-water')
            .offset([-10, 0])
            .html((d) ->
              return "<span>" + d + "</span>";
            )
          d3.select(chartContainer[0]).select("svg").remove()
          svg = d3.select(chartContainer[0])
            .append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .attr("class", "graph-water")
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
          y.domain([0,10])
          x.domain(d3.extent(waterData, (d, i) ->
              return i
            )
          )
          svg.call(tip)
          # area
          svg.append("path")
            .datum(waterStartData)
            .attr("class", "area")
            .attr("d", area)
            .style("fill", "rgba(200,240,255,0.3)")
            .transition()
            .duration(500)
            .attrTween( 'd', ->
              interpolator = d3.interpolateArray(waterStartData,waterData)
              return (t) ->
                return area(interpolator(t))
            )
          # line
          svg.append("path")
            .datum(waterStartData)
            .attr("class", "line")
            .attr("d", line)
            .style("stroke", "rgba(107,197,232,0.8)")
            .style("stroke-width", "2")
            .style("fill", "none")
            .transition()
            .duration(500)
            .attrTween( 'd', ->
              interpolator = d3.interpolateArray(waterStartData,waterData)
              return (t) ->
                return line(interpolator(t))
            )

          focus = svg.append("g")
            .append("circle")
            .style("display", "none")
            .attr("id", "point")
            .attr("fill", "rgba(107,197,232,1)")
            .attr("r", 2)
          svg
            .append("rect")
            .attr("width", width)
            .attr("height", height)
            .style("fill", "none")
            .style("pointer-events", "all")
            .on "mouseover", () ->
              focus.style "display", 'inline'
            .on "mouseout", () ->
              focus.style "display", "none"
              tip.hide()
            .on "mousemove", () ->
              x0 = x.invert(d3.mouse(this)[0])
              i = Math.ceil(x0)
              d = waterData[i]
              if d == 0
                return
              focus.attr "transform", "translate(" + x(i) + "," + y(d) + ")"
              tip.show(d, focus.node())
              return
          return svg

        # Fitness mark chart func
        fitnessMarkChart = () ->
          fitnessMarkStartData = [0]
          fitnessMarkData = [0]
          for weekNumber, mark of data
            fitnessMarkData.push(mark)
            fitnessMarkStartData.push(0)
          margin =
            top: 5
            right: 5
            bottom: 5
            left: 5

          width = totalWidth - margin.left - margin.right
          height = totalHeight - margin.top - margin.bottom
          x = d3.scale.linear().range([0,width])
          y = d3.scale.linear().range([height,0])
          line = d3.svg.line()
            .x((d, i) ->
              x(i)
            )
            .y((d) ->
              y(d)
            )
          tip = d3.tip()
            .attr('class', 'd3-tip tip-fitness')
            .offset([-10, 0])
            .html((d) ->
              return "<span>" + d + "</span>";
            )
          d3.select(chartContainer[0]).select("svg").remove()
          svg = d3.select(chartContainer[0])
            .append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .attr("class", "graph-fitness")
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
          y.domain([0,100])
          x.domain(d3.extent(fitnessMarkData, (d, i) ->
              return i
            )
          )
          svg.call(tip)
          svg.append("path")
            .datum(fitnessMarkStartData)
            .attr("d", line)
            .attr("class", "line")
            .style("fill", "none")
            .style("stroke", "rgba(233,120,70,0.7)")
            .style("stroke-width", "2")
            .transition()
            .duration(500)
            .attrTween( 'd', ->
              interpolator = d3.interpolateArray(fitnessMarkStartData,fitnessMarkData)
              return (t) ->
                return line(interpolator(t))
            )
            .each("end", () ->
              svg.selectAll(".point")
              .data(fitnessMarkData)
              .enter()
              .append("svg:circle")
              .attr("class", (d, i) ->
                if d == 0 and i > 0
                  return "line-circle disable"
                else
                  return "line-circle"
              )
              .attr("stroke", "rgba(233,120,70,0.7)")
              .style("stroke-width", "3")
              .attr("fill", "#fff")
              .attr("cx", (d, i) ->
                x(i)
              )
              .attr("cy", (d) ->
                y(d)
              )
              .attr("r", 3)
              .on('mouseover', (d)->
                if d > 0
                  tip.show(d)
              )
              .on('mouseout', tip.hide)
            )

          return svg

        # Cravings hunger mood chart func
        cravingsHungerMoodChart = () ->
          # data
          cravingsHungerData = []
          moodData = [0]
          moodStartData = [0]
          for date, mood of data.moodData
            moodData.push(mood)
            moodStartData.push(0)
          for date, cravings of data.cravingsData
            hunger = 0
            if data.hungerData[date] isnt undefined
              hunger = data.hungerData[date]
            cravingsHungerData.push({
              hunger: hunger
              cravings: cravings
            })

          smiles = {
            1: '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" 	 width="16px" height="16px" viewBox="0 0 16 16" enable-background="new 0 0 16 16" xml:space="preserve"> <g> 	<g> 		<path fill-rule="evenodd" clip-rule="evenodd" fill="#FD7B6E" d="M8.006,8.786c-1.704,0-3.103,1.257-3.351,2.894 			c0.148,0.143,0.308,0.252,0.462,0.252c0.332,0,0.529-0.076,0.734-0.236c0.215-0.977,1.088-1.709,2.136-1.709 			c1.027,0,1.879,0.707,2.112,1.658c0.186,0.139,0.454,0.285,0.785,0.285c0.204,0,0.352-0.102,0.473-0.238 			C11.114,10.049,9.713,8.786,8.006,8.786z M10.358,6.689c0.579,0,1.049-0.469,1.049-1.048s-0.47-1.048-1.049-1.048 			c-0.578,0-1.048,0.469-1.048,1.048S9.78,6.689,10.358,6.689z M5.641,6.689c0.579,0,1.048-0.469,1.048-1.048 			S6.22,4.592,5.641,4.592S4.593,5.062,4.593,5.641S5.062,6.689,5.641,6.689z M8,0.399C3.802,0.399,0.399,3.802,0.399,8 			S3.802,15.6,8,15.6c4.197,0,7.601-3.402,7.601-7.6S12.197,0.399,8,0.399z M8,14.291c-3.475,0-6.292-2.816-6.292-6.292 			S4.525,1.707,8,1.707c3.476,0,6.292,2.817,6.292,6.292S11.476,14.291,8,14.291z M11.348,12.182c0.035,0.006,0.061,0.01,0.061,0.01 			c0-0.033-0.009-0.064-0.01-0.098C11.382,12.123,11.364,12.152,11.348,12.182z"/> 	</g> </g> </svg>'
            2: '<svg version="1.1" id="Слой_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" 	 width="16px" height="16px" viewBox="0 0 16 16" enable-background="new 0 0 16 16" xml:space="preserve"> <g> 	<g> 		<path fill-rule="evenodd" clip-rule="evenodd" fill="#FD7B6E" d="M8,0.4c-4.198,0-7.601,3.403-7.601,7.601 			c0,4.198,3.403,7.601,7.601,7.601c4.197,0,7.601-3.402,7.601-7.601C15.601,3.803,12.197,0.4,8,0.4z M8,14.293 			c-3.475,0-6.292-2.816-6.292-6.292c0-3.475,2.817-6.292,6.292-6.292c3.475,0,6.293,2.817,6.293,6.292 			C14.293,11.477,11.475,14.293,8,14.293z M6.689,5.642c0-0.579-0.469-1.048-1.048-1.048c-0.579,0-1.048,0.47-1.048,1.048 			c0,0.579,0.47,1.049,1.048,1.049C6.22,6.691,6.689,6.221,6.689,5.642z M10.359,4.594c-0.58,0-1.049,0.47-1.049,1.048 			c0,0.579,0.469,1.049,1.049,1.049c0.578,0,1.048-0.47,1.048-1.049C11.407,5.063,10.938,4.594,10.359,4.594z M9.835,9.836H6.166 			c-0.29,0-1.048,0.234-1.048,0.523v0.525c0,0.289,0.759,0.523,1.048,0.523h3.669c0.29,0,1.048-0.234,1.048-0.523v-0.525 			C10.883,10.07,10.125,9.836,9.835,9.836z"/> 	</g> </g> </svg>'
            3: '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" 	 width="16px" height="16px" viewBox="0 0 16 16" enable-background="new 0 0 16 16" xml:space="preserve"> <g> 	<g> 		<path fill-rule="evenodd" clip-rule="evenodd" fill="#F7CF2E" d="M10.359,4.593c-0.58,0-1.049,0.469-1.049,1.048 			s0.469,1.048,1.049,1.048c0.578,0,1.048-0.469,1.048-1.048S10.938,4.593,10.359,4.593z M9.782,8.788 			C9.35,8.808,8.844,8.844,8.271,8.843c-0.489,0-0.711,0.086-0.869,0.188c0.373,0.174,0.687,0.3,0.869,0.328 			C7.794,9.283,8.997,9.059,9.782,8.788z M8,0.399C3.802,0.399,0.399,3.802,0.399,8c0,4.198,3.403,7.601,7.601,7.601 			c4.197,0,7.601-3.402,7.601-7.601C15.601,3.802,12.197,0.399,8,0.399z M8,14.292c-3.475,0-6.292-2.816-6.292-6.292 			c0-3.475,2.817-6.292,6.292-6.292c3.475,0,6.293,2.817,6.293,6.292C14.293,11.476,11.475,14.292,8,14.292z M6.689,5.641 			c0-0.579-0.469-1.048-1.048-1.048S4.593,5.062,4.593,5.641s0.469,1.048,1.048,1.048S6.689,6.22,6.689,5.641z M10.361,10.407 			c-0.489,0-0.687,0.145-1.046,0.516c-0.394,0.407-2.617,0.001-2.617,0.001s-0.437-0.565-1.057-0.565 			c-0.188,0-0.366,0.235-0.527,0.485c0.597,0.964,1.662,1.612,2.889,1.612c1.216,0,2.274-0.636,2.874-1.584 			C10.858,10.756,10.773,10.407,10.361,10.407z"/> 	</g> </g> </svg>'
            4: '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" 	 width="16px" height="16px" viewBox="0 0 16 16" enable-background="new 0 0 16 16" xml:space="preserve"> <g> 	<g> 		<path fill-rule="evenodd" clip-rule="evenodd" fill="#8CC152" d="M9.788,8.9C9.354,8.92,8.846,8.957,8.271,8.956 			c-0.488,0-0.71,0.086-0.868,0.188C7.7,9.285,7.976,9.399,8.178,9.446C8.029,9.352,9.08,9.146,9.788,8.9z M10.359,4.706 			c-0.579,0-1.049,0.469-1.049,1.048s0.47,1.048,1.049,1.048s1.048-0.469,1.048-1.048S10.938,4.706,10.359,4.706z M5.642,6.803 			c0.579,0,1.048-0.469,1.048-1.048S6.221,4.706,5.642,4.706S4.593,5.175,4.593,5.754S5.062,6.803,5.642,6.803z M10.887,9.473 			c-0.49,0-0.688,0.145-1.047,0.516c-0.394,0.407-3.665,0.001-3.665,0.001S5.738,9.424,5.117,9.424c-0.158,0-0.31,0.169-0.451,0.371 			c0.279,1.574,1.663,2.773,3.336,2.773c1.686,0,3.073-1.215,3.341-2.804C11.279,9.625,11.155,9.473,10.887,9.473z M8,0.513 			c-4.197,0-7.601,3.403-7.601,7.601c0,4.197,3.403,7.601,7.601,7.601c4.198,0,7.601-3.403,7.601-7.601 			C15.601,3.916,12.198,0.513,8,0.513z M8,14.406c-3.475,0-6.292-2.818-6.292-6.293c0-3.475,2.817-6.292,6.292-6.292 			c3.476,0,6.293,2.817,6.293,6.292C14.293,11.588,11.476,14.406,8,14.406z"/> 	</g> </g> </svg>'
            5: '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" 	 width="16px" height="16px" viewBox="0 0 16 16" enable-background="new 0 0 16 16" xml:space="preserve"> <g> 	<g> 		<path fill-rule="evenodd" clip-rule="evenodd" fill="#8CC152" d="M5.7,6.758c0.579,0,1.048-0.469,1.048-1.048 			S6.279,4.662,5.7,4.662S4.651,5.131,4.651,5.71S5.121,6.758,5.7,6.758z M8.059,0.468c-4.197,0-7.601,3.403-7.601,7.601 			s3.403,7.601,7.601,7.601c4.198,0,7.601-3.403,7.601-7.601S12.257,0.468,8.059,0.468z M8.059,14.361 			c-3.475,0-6.292-2.817-6.292-6.292s2.817-6.292,6.292-6.292c3.476,0,6.292,2.817,6.292,6.292S11.534,14.361,8.059,14.361z 			 M10.418,4.662c-0.579,0-1.049,0.469-1.049,1.048s0.47,1.048,1.049,1.048c0.578,0,1.048-0.469,1.048-1.048 			S10.996,4.662,10.418,4.662z M10.68,8.855H5.438c-0.434,0-0.786,0.235-0.786,0.524c0,0.106,0.059,0.199,0.14,0.282 			C4.769,9.69,4.746,9.719,4.724,9.751c0.28,1.575,1.663,2.773,3.337,2.773c1.686,0,3.073-1.215,3.341-2.805 			c-0.014-0.028-0.031-0.058-0.05-0.085c0.065-0.077,0.113-0.161,0.113-0.256C11.466,9.09,11.114,8.855,10.68,8.855z M8.08,11.342 			c-0.953,0-1.746-0.604-2.041-1.438h4.096C9.837,10.738,9.034,11.342,8.08,11.342z"/> 	</g> </g> </svg>'
          }

          margin =
            top: 0
            right: 0
            bottom: 0
            left: 0

          width = totalWidth - margin.left - margin.right
          height = totalHeight - margin.top - margin.bottom
          x = d3.scale.linear().range([0,width])
          xBars0 = d3.scale.ordinal().rangeBands([0,width], 0.2)
          xBars1 = d3.scale.ordinal()
          x2Values = []
          part = width / 56
          i = 0
          while i <= 56
            x2Values[i] = (part * i) / width
            i++
          x3Values = []
          part = width / 8
          i = 0
          while i <= 7
            x3Values[i] = (part * i) / width
            i++
          y2Values = []
          j = 0
          while j <= 20
            if y2Values[j - 1]?
              y2Values[j] = y2Values[j - 1] + 0.05
            else
              y2Values[0] = 0
            j++
          x2 = d3.scale.linear()
            .domain([0,1])
            .range([0,width])
          x2Axis = d3.svg.axis()
            .scale(x2)
            .tickValues(x2Values)
            .tickSize(-height, 0, 0)
            .tickFormat("")
          x3Axis = d3.svg.axis()
            .scale(x2)
            .tickValues(x3Values)
            .tickSize(-height, 0, 0)
            .tickFormat("")
          y = d3.scale.linear()
            .range([height,0])
          y2 = d3.scale.linear()
            .domain([0,1])
            .range([0,height * 2])
          yAxis = d3.svg.axis()
            .scale(y2)
            .orient("left")
            .ticks(24)
            .tickValues(y2Values)
            .tickSize(-width, 0, 0)
            .tickFormat("")
          color = d3.scale.ordinal()
            .range(["#a8a9ba", "#b3d896"])
          tipCraving = d3.tip()
            .attr('class', 'd3-tip tip-cravings')
            .offset([-10, 0])
            .html((d) ->
              return "<span>" + d.value + "</span>"
            )
          tipHunger = d3.tip()
            .attr('class', 'd3-tip tip-hunger')
            .offset([-10, 0])
            .html((d) ->
              return "<span>" + d.value + "</span>";
            )
          tipMood = d3.tip()
            .attr('class', 'd3-tip tip-mood')
            .offset([-10, 0])
            .html((d) ->
              if smiles[d] isnt undefined
                return smiles[d]
              else
                return ''
            )

          areaMood = d3.svg.area()
            .x((d, i) ->
              x(i)
            )
            .y0(height)
            .y1((d) ->
              if d > 0
                y(d) - (height/2 -height/10)
              else
                y(d)
            )
            .interpolate("cardinal")
          lineMood = d3.svg.line()
            .x((d, i) ->
              x(i)
            )
            .y((d) ->
              if d > 0
                y(d) - (height/2 - height/10)
              else
                y(d)
            )
            .interpolate("cardinal")

          # svg
          d3.select(chartContainer[0]).select("svg").remove()
          svg = d3.select(chartContainer[0])
            .append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .attr("class", "graph")
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
          # grid
          svg.append("g")
            .attr("class", "y axis grid")
            .call yAxis
          svg.append("g")
            .attr("class", "x axis grid")
            .attr("transform", "translate(0," + height + ")")
            .call x2Axis
          svg.append("g")
            .attr("class", "x-week axis grid")
            .attr("transform", "translate(0," + height + ")")
            .call x3Axis
          # tips
          svg.call(tipCraving)
          svg.call(tipHunger)
          svg.call(tipMood)

          y.domain([0,10])
          x.domain([0,55])

          # mood area chart
          moodChart = svg.append("g")
            .attr("class", "chart mood")
            .attr("id", "mood-chart")
            .attr("data-sort-layer", "mood")
          moodChart.append("path")
          .datum(moodStartData)
          .attr("class", "area")
          .attr("id", "area-mood")
          .attr("d", areaMood)
          .style("fill", "rgba(145,113,148,0.08)")
          .transition()
          .duration(500)
          .attrTween( 'd', ->
            interpolator = d3.interpolateArray(moodStartData,moodData)
            return (t) ->
              return areaMood(interpolator(t))
          )

          # mood line chart
          moodChart.append("path")
            .datum(moodStartData)
            .attr("class", "line")
            .attr("d", lineMood)
            .style("stroke", "rgba(164,159,184,0.9)")
            .style("stroke-width", "2")
            .style("fill", "none")
            .transition()
            .duration(500)
            .attrTween( 'd', ->
              interpolator = d3.interpolateArray(moodStartData,moodData)
              return (t) ->
                return lineMood(interpolator(t))
            )
            .each "end", () ->
              focusMood = svg.append("g")
                .append("circle")
                .style("display", "none")
                .attr("id", "point")
                .attr("fill", "rgba(164,159,184,1)")
                .attr("r", 2)
              moodChart.append("rect")
                .attr("id", "canvas")
                .attr("width", width)
                .attr("height", height)
                .style("fill", "none")
                .style("pointer-events", "all")
                .on "mouseover", () ->
                  focusMood.style "display", 'inline'
                .on "mouseout", () ->
                  focusMood.style "display", "none"
                  tipMood.hide()
                .on "mousemove", () ->
                  x0 = x.invert(d3.mouse(this)[0])
                  i = Math.ceil(x0)
                  d = moodData[i]
                  if d > 0
                    h = y(d) - (height/2 -height/10)
                  else
                    h = y(d)
                  if d == 0
                    return
                  if isNaN(h) or h == 0
                    return
                  focusMood.attr "transform", "translate(" + x(i) + "," + h + ")"
                  tipMood.show(d, focusMood.node())
                  return

              svg.append('use')
                .attr("id", "use-chart")
                .attr("xlink:href", "#hunger-cravings-chart")

          # bars
          barNames = ['hunger','cravings']
          cravingsHungerData.forEach((d) ->
            d.bars = barNames.map((name) ->
              return {name: name, value: d[name]}
            )
          )
          xBars0.domain(cravingsHungerData.map((d,i) ->
            return i
          ))
          xBars1.domain(barNames).rangeBands([0, xBars0.rangeBand()])
          cravingsHunger = svg.append("g")
            .attr("class", "hunger-cravings chart active")
            .attr("id", "hunger-cravings-chart")
            .attr("data-sort-layer", "hunger-cravings")
            .attr("transform", "translate(1.5,3)")
          cravingsHunger
            .append("rect")
            .attr("id", "canvas")
            .attr("width", width)
            .attr("height", height)
            .style("fill", "none")
            .style("pointer-events", "all")
          barBox = cravingsHunger.selectAll(".bar-box")
            .data(cravingsHungerData)
            .enter()
            .append("g")
            .attr("class", "bar-box")
            .attr("transform", (d,i) ->
              tr = (xBars0(i) - xBars0(0))
              return "translate(" + tr + ",0)"
          )
          barBox.selectAll("rect")
            .data((d) ->
              return d.bars
            )
            .enter().append("rect")
            .attr("width", xBars1.rangeBand())
            .attr("x", (d) ->
              return xBars1(d.name)
            )
            .attr("y", height)
            .style("fill", (d) ->
              return color(d.name)
            )
            .attr("rx", 1)
            .on('mouseover', (d) ->
              if d.name == 'cravings'
                tipCraving.show(d)
              else if d.name == 'hunger'
                tipHunger.show(d)
            )
            .on('mouseout', (d) ->
              if d.name == 'cravings'
                tipCraving.hide(d)
              else if d.name == 'hunger'
                tipHunger.hide(d)
            )
            .attr("height", 0)
            .transition()
            .duration(500)
            .attr("y", (d) ->
              return y(d.value) - 3
            )
            .attr("height", (d) ->
              return height - y(d.value)
            )

          return svg

        # Cravings hunger mood chart func
        cigarettesGlucoseChart = () ->
          glucoseData = [3]
          glucoseStartData = [3]
          cigarettesData = [0]
          cigarettesStartData = [0]
          for date, glucose of data.glucoseData
            glucoseData.push(glucose)
            glucoseStartData.push(3)
          for date, cigarettes of data.cigarettesData
#            if cigarettes > 0
#              cigarettes = cigarettes * 10 - 5
            cigarettesData.push(cigarettes)
            cigarettesStartData.push(0)
          margin =
            top: 0
            right: 0
            bottom: 0
            left: 0

          width = totalWidth - margin.left - margin.right
          height = totalHeight - margin.top - margin.bottom
          xGlucose = d3.scale.linear().range([0,width])
          xCigarettes = d3.scale.linear().range([0,width])
          x2Values = []
          part = width / 56
          i = 0
          while i <= 56
            x2Values[i] = (part * i) / width
            i++
          x3Values = []
          part = width / 8
          i = 0
          while i <= 7
            x3Values[i] = (part * i) / width
            i++
          y2Values = []
          j = 0
          while j <= 20
            if y2Values[j - 1]?
              y2Values[j] = y2Values[j - 1] + 0.05
            else
              y2Values[0] = 0
            j++
          x2 = d3.scale.linear()
            .domain([0,1])
            .range([0,width])
          x2Axis = d3.svg.axis()
            .scale(x2)
            .tickValues(x2Values)
            .tickSize(-height, 0, 0)
            .tickFormat("")
          x3Axis = d3.svg.axis()
            .scale(x2)
            .tickValues(x3Values)
            .tickSize(-height, 0, 0)
            .tickFormat("")
          yGlucose = d3.scale.linear()
            .range([height,0])
          yCigarettes = d3.scale.linear()
            .range([height,0])
          y2 = d3.scale.linear()
            .domain([0,1])
            .range([0,height * 2])
          yAxis = d3.svg.axis()
            .scale(y2)
            .orient("left")
            .ticks(24)
            .tickValues(y2Values)
            .tickSize(-width, 0, 0)
            .tickFormat("")
          tipGlucose = d3.tip()
            .attr('class', 'd3-tip tip-glucose')
            .offset([-10, 0])
            .html((d) ->
              return "<span>" + d + "</span>";
            )
          tipCigarettes = d3.tip()
            .attr('class', 'd3-tip tip-cigarettes')
            .offset([-10, 0])
            .html((d) ->
              return "<span>" + d + "</span>";
            )

          area = d3.svg.area()
            .x((d, i) ->
              xGlucose(i)
            )
            .y0(height)
            .y1((d) ->
              yGlucose(d)
            )
            .interpolate("cardinal")
          line = d3.svg.line()
            .x((d, i) ->
              xGlucose(i)
            )
            .y((d) ->
              yGlucose(d)
            )
            .interpolate("cardinal")
          lineCigarettes = d3.svg.line()
            .x((d, i) ->
              xCigarettes(i)
            )
            .y((d) ->
              yCigarettes(d)
            )
          # svg
          d3.select(chartContainer[0]).select("svg").remove()
          svg = d3.select(chartContainer[0])
            .append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .attr("class", "graph-week")
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
          # grid
          svg.append("g")
            .attr("class", "y axis grid")
            .call yAxis
          svg.append("g")
            .attr("class", "x axis grid")
            .attr("transform", "translate(0," + height + ")")
            .call x2Axis
          svg.append("g")
            .attr("class", "x-week axis grid")
            .attr("transform", "translate(0," + height + ")")
            .call x3Axis
          # tips
          svg.call(tipGlucose)
          svg.call(tipCigarettes)

          # glucose chart
          yGlucose.domain([3,8])
          xGlucose.domain(d3.extent(glucoseData, (d, i) ->
              return i
            )
          )
          glucoseChart = svg.append("g")
            .attr("class", "glucose chart")
            .attr("id", "glucose-chart")
            .attr("data-sort-layer", "glucose")
          glucoseChart.append("path")
            .datum(glucoseStartData)
            .attr("class", "area")
            .attr("d", area)
            .style("fill", "rgba(244,200,200,0.3)")
            .transition()
            .duration(500)
            .attrTween( 'd', ->
              interpolator = d3.interpolateArray(glucoseStartData,glucoseData)
              return (t) ->
                return area(interpolator(t))
            )
          glucoseChart.append("path")
            .datum(glucoseStartData)
            .attr("class", "line")
            .attr("d", line)
            .style("stroke", "rgba(221,126,120,0.8)")
            .style("stroke-width", "2")
            .style("fill", "none")
            .transition()
            .duration(500)
            .attrTween( 'd', ->
              interpolator = d3.interpolateArray(glucoseStartData,glucoseData)
              return (t) ->
                return line(interpolator(t))
            )
            .each "end", () ->
              focusGlucose = svg.append("g")
              focusGlucoseCircle = focusGlucose
                .append("circle")
                .style("display", "none")
                .attr("id", "point")
                .attr("fill", "rgba(221,126,120,0.8)")
                .attr("r", 3)
              glucoseChart.append("rect")
                .attr("id", "canvas")
                .attr("width", width)
                .attr("height", height)
                .style("fill", "none")
                .style("pointer-events", "all")
                .on "mouseover", () ->
                  focusGlucose.style "display", 'inline'
                .on "mouseout", () ->
                  focusGlucose.style "display", "none"
                  tipGlucose.hide()
                .on "mousemove", () ->
                  x0 = xGlucose.invert(d3.mouse(this)[0])
                  i = Math.ceil(x0)
                  d = glucoseData[i]
                  if d <= 3
                    return
                  h = yGlucose(d)
                  if isNaN(h) or h == 0
                    return
                  focusGlucose.attr "transform", "translate(" + xGlucose(i) + "," + h + ")"
                  tipGlucose.show(d, focusGlucoseCircle.node())
                  return

          # cigarettes chart
          yCigarettes.domain([0,50])
          xCigarettes.domain(d3.extent(cigarettesData, (d, i) ->
              return i
            )
          )
          cigarettesChart = svg.append("g")
            .attr("class", "cigarettes chart")
            .attr("id", "cigarettes-chart")
            .attr("data-sort-layer", "cigarettes")
          cigarettesChart.append("path")
            .datum(cigarettesStartData)
            .attr("class", "line")
            .attr("d", lineCigarettes)
            .style("stroke", "rgba(225,155,2,0.8)")
            .style("stroke-width", "2")
            .style("fill", "none")
            .transition()
            .duration(500)
            .attrTween( 'd', ->
              interpolator = d3.interpolateArray(cigarettesStartData,cigarettesData)
              return (t) ->
                return lineCigarettes(interpolator(t))
            )
            .each "end", () ->
              focusCigarettes = svg.append("g")
                .append("circle")
                .style("display", "none")
                .attr("id", "point")
                .attr("fill", "rgba(225,155,2,1)")
                .attr("r", 3)
              cigarettesChart.append("rect")
                .attr("id", "canvas")
                .attr("width", width)
                .attr("height", height)
                .style("fill", "none")
                .style("pointer-events", "all")
                .on "mouseover", () ->
                  focusCigarettes.style "display", 'inline'
                .on "mouseout", () ->
                  focusCigarettes.style "display", "none"
                  tipCigarettes.hide()
                .on "mousemove", () ->
                  x0 = xCigarettes.invert(d3.mouse(this)[0])
                  i = Math.ceil(x0)
                  d = cigarettesData[i]
                  if d == 0
                    return
                  h = yCigarettes(d)
                  if isNaN(h) or h == 0
                    return
                  focusCigarettes.attr "transform", "translate(" + xCigarettes(i) + "," + h + ")"
                  tipCigarettes.show(d, focusCigarettes.node())
                  return
              svg.append('use')
                .attr("id", "use-chart")
                .attr("xlink:href", "#cigarettes-chart")

          return svg

        cravingsHungerMoodSort = (chartType, data) ->
          svg = svgContainers[chartType]
          layer = data.activeChart
          if layer == 'hunger-cravings'
            svg.select("#use-chart")
              .attr("xlink:href", "#hunger-cravings-chart")
            svg.select("#mood-chart")
            .classed("active", false)
            svg.select("#hunger-cravings-chart")
            .classed("active", true)
          else if layer == "mood"
            svg.select("#use-chart")
            .attr("xlink:href", "#mood-chart")
            svg.select("#hunger-cravings-chart")
            .classed("active", false)
            svg.select("#mood-chart")
            .classed("active", true)

        cigarettesGlucoseSort = (chartType, data) ->
          svg = svgContainers[chartType]
          layer = data.activeChart
          if layer == 'glucose'
            svg.select("#use-chart")
            .attr("xlink:href", "#glucose-chart")
            svg.select("#cigarettes-chart")
            .classed("active", false)
            svg.select("#glucose-chart")
            .classed("active", true)
          else if layer == "cigarettes"
            svg.select("#use-chart")
            .attr("xlink:href", "#cigarettes-chart")
            svg.select("#glucose-chart")
            .classed("active", false)
            svg.select("#cigarettes-chart")
            .classed("active", true)

        # ----------------
#        w = angular.element($window)
#        resizePromise = null
#        w.bind "resize", (ev) ->
#          resizePromise and $timeout.cancel(resizePromise)
#          resizePromise = $timeout(->
#            totalWidth = element[0].clientWidth
#            totalHeight = element[0].clientHeight
#            init()
#            return
#          , 100)
#          return
#
#        scope.getWindowDimensions = ->
#          h: w[0].clientHeight
#          w: w[0].clientWidth


        # Watch for any of the config changing.
        scope.$watch "[statChart, statData, statConfig]", init, true
        scope.$watch "[statSubData]", subDataHandler, true

#        scope.$watch (->
#          w: element[0].clientWidth
#          h: element[0].clientHeight
#        ), ((newvalue) ->
#          totalWidth = newvalue.w
#          totalHeight = newvalue.h
#          init()
#          return
#        ), true
  ]
