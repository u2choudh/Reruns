$(document).ready(function() {
	var seasons = {}
	var seriesId = 0

	$('.btn-dark').on('click', function(){
		$(this).toggleClass('btn-danger btn-dark selected')
		seriesId = $(this).parents('.card').attr('id-val')
		
		let num = $(this).val()
		
		if ($(this).hasClass('selected')){
			seasons[num] = true
		} else {
			seasons[num] = false
		}
	})

	$('.generate-episode').on('click', function() {
		selectedSeries = []
		let curSeriesId = $(this).parents('.card').attr('id-val')
		Object.keys(seasons).forEach(function(key) {
  		if (seasons[key] == true) selectedSeries.push(key)
		})

		if (curSeriesId !== seriesId){
			console.log('error')
		}

		$.ajax({
      type: "POST",
      url: "/generate_episode",
      data: { seasons: selectedSeries, id: curSeriesId},
      dataType: "json",
      'success' : function(data) {
      	console.log(data)
      	$('#episodeModal .modal-title').html(`<i class="fa fa-tv"></i> Season ${data.season}, Ep ${data.epnum}`)
      	$('#episodeModal .modal-body .title').html(data.title)
      	$('#episodeModal .modal-body .description').html(data.description)
      	$('#episodeModal .modal-footer .rating').html(`${data.rating}  <i class="fa fa-star"></i>`)
      	
      	if (data.netflix_id !== null) {
      		$('#episodeModal .modal-footer .netflix-btn').html(`<a href="https://www.netflix.com/watch/${data.netflix_id}" target=_blank>Watch on Netflix <i class="fa fa-play-circle"></i></a>`)
      	}

      	$('#episodeModal').modal('show')
        return false
      },
      'error' : function(request, error) {
        alert('Please select a seasons for your series')
        return false
      }
    })
	})

	$('.delete-series').on('click', function() {
		let series_id = $(this).attr('value')

		$.ajax({
      type: "DELETE",
      url: "/delete_series",
      data: { id: series_id },
      dataType: "json",
      'success' : function(data) {
      	window.location.reload()
        return false
      },
      'error' : function(request, error) {
        alert('Series not deleted')
        return false
      }
    })
	})

	$('.include-all').on('click', function() {

	})
})


