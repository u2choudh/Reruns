$(document).ready(function() {
	$('.series-search').on('click', function(){
		let input = $('#series-name').val()

		// check for empty input and do nothing
		if (input === '') {
			return
		}

		// Request to submit search for scrape and results 
		$.ajax({
      type: "POST",
      url: "imdb/" + input,
      dataType: "json",
      'success' : function(data) {
        displayResults(data)
        return false
      },
      'error' : function(request, error) {
        alert('Please enter a valid title name')
        return false
      }
    })
	})

	// Search on enter keypress
	$('#series-name').keypress(function (e) {
		let key = e.which
	  if(key == 13) {
	    $('.series-search').click()
	    return false;  
	  }
	});

	// Add series button click functionality
	$('#search-list').on('click', '.add-series', function(){
		let name = $(this).siblings('.name').attr('text')
		let url = $(this).siblings('.name').attr('url') 
		let year = $(this).siblings('.year').attr('text')
		let rating = $(this).siblings('.rating').attr('text')

		$.ajax({
      type: "POST",
      url: "add_series/",
      data: { title: name, url: url, year: year, rating: rating},
      dataType: "json",
      'success' : function(data) {
        location.href = "/rerun_favorites"
        return false
      },
      'error' : function(request, error) {
        alert('Series could not be added')
        return false
      }
    })
	})
})

function displayResults(data) {
	let $container = $('.results #search-list')
	let html = ``

	for(let series of data) {
		url = "https://www.imdb.com" + series[1]
		html += `
			<tr>
	      <td class="name" text="${series[0]}" url="${url}"><a href="${url}" target=_blank><i class="fa fa-tv"></i> ${series[0]}</a></td>
	      <td class="year" text="${series[2]}">${series[2]}</td>
	      <td class="rating" text="${series[3]}">${series[3]} <i class="fa fa-star"></i></td>
	      <td class="add-series"><button class="btn btn-success">Add Series</button></td>
	    </tr>
		` 
	}

	$container.html(html)
}

