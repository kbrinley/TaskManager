/**
 * @author Sand Bridge Software
 */

	$(document).ready(function() {
		if ($('#percentcompleteenabled').html() == 'true')
		{	
			$('div.field').removeClass('percentcomplete')
		}
				
		$('.help').click(function (){
			var shtml = $(this).attr('alt');
			var $dialog = $('<div></div>').html(shtml)
			.dialog({
				autoOpen: false,
				title: "Help"
			});
			$dialog.dialog('open');
		});
		
		$('#btnshownewgoal').click(function () {
			$('div.new_goal').dialog('open');
		});
	
		$('div.goals').shortscroll();
		$('div.tasks').shortscroll();
		
		$('#btnshownewtask').click(function (){
			$('div.new_task').dialog('open');
			$('div.new_task #task_description').focus();
			return false;
		});
		
		if ($(window).width() <= 1024)
		{
			//$('.whiteboard').css('background', 'url(\'/images/Whiteboard_small.png\') no-repeat');
			$('.container').css('width', '174px');
			$('.taskrecord').css('width', '150px');
			$('.goalcontainer').css('width', '300px');
			$('.goalrecord').css('width', '270px');
		}
		
		$('div.new_task').dialog({
			autoOpen: false,
			title: "Create a New Task",
			height: 350,
			width: 600
		});
		
		$('div.edit_task').dialog({
			autoOpen: false,
			title: "Edit Task",
			height: 350,
			width: 600
		});
		
		$('div.new_goal').dialog({
			autoOpen: false,
			title: "Create a New Goal",
			height: 350,
			width: 600
		});
		
		$('div.edit_goal').dialog({
			autoOpen: false,
			title: "Edit Goal",
			height: 350,
			width: 600
		});
		
		$('.taskrecord').draggable({
			cursor: 'move',
			helper: 'clone',
			scroll: false
		}).disableSelection();
		
		$('button.copygoal').live('click', function(event){
			// authenticity_token=QYU%2FXIYPcqi%2FFKxkq%2BCHKAA3AjwehzvP3niO2Df0vlI%3D
			// &goal%5Bgoaltype_id%5D=1
			// &goal%5Bdescription%5D=Test
			// &goal%5Bpercentcomplete%5D=
			var auth_token = $('div#authtoken').html();
			var desc = $('textarea#edit_task_description').val();
			var pcnt = $('#edit_task_percentcomplete').val();
			var data = {authenticity_token: auth_token,
						goal: { goaltype_id: $(this).attr("goaltype_id"),
								description: desc,
								percentcomplete: pcnt}};
			$.ajax({
				url: '/goals',
				type: 'post',
				data: $.param(data), // This will have to be specially crafted
				success:
					function(response, status, xhr) {
						alert("Releated Goal successfully created.");
					},
				failure:
					function(response, status, xhr) {
						alert("Failed to create related Goal.");
					}
			});
			return false;
		});
		
		$('#btncreaterelatedtask').live('click', function(event){
			// authenticity_token=QYU%2FXIYPcqi%2FFKxkq%2BCHKAA3AjwehzvP3niO2Df0vlI%3D
			// &task%5Bcategory_id%5D=86
			// &task%5Bdescription%5D=Test+1
			// &task%5Bpercentcomplete%5D=
			var auth_token = $('div#authtoken').html();
			var desc = $('textarea#edit_goal_description').val();
			var pcnt = $('#edit_goal_percentcomplete').val();
			var data = {authenticity_token: auth_token, 
						task: { category_id: '0', 
							 	description: desc,
							 	percentcomplete: pcnt}};
			$.ajax({
				url: '/tasks',
				type: 'post',
				data: $.param(data), // This will have to be specially crafted
				success:
					function(response, status, xhr) {
						alert("Releated Task successfully created.");
					},
				failure:
					function(response, status, xhr) {
						alert("Failed to create related Task.");
					}
			});
			return false;
		});
		
		// Insert code to ajaxy create tasks
		$('form#new_task div.actions input#task_submit').live('click', function(event){
			var category_id = $('select#task_category_id').val();
			$.ajax({
				url: '/tasks',
				type: 'post',
				data: $('form#new_task').serialize(),
				success: 
					function(response, status, xhr) {
						// Close Edit dialog
						$('div.new_task').dialog('close');
						// Add New Task to screen
						// the response contains the html, we need to append it to the 
						// selected category.
						$('div.whiteboard > div').filter(function() { if ($('#category_id', this).html() == category_id) return true; else return false;}).find('div.tasks').append(response);
						$('.taskrecord').draggable({
							cursor: 'move',
							helper: 'clone'
						});
		
						$('.taskrecord').disableSelection();
						//Update Counts at top of page
						$('span#activeTasks').html(parseInt($('span#activeTasks').html()) + 1);
						$('span#countTotals').html(parseInt($('span#countTotals').html()) + 1);
						$('select#task_category_id').val('');
						$('form#new_task textarea#task_description').val('');
						$('form#new_task #task_percentcomplete').val('');
						}, 
				error:
					function(response, status, xhr) {
						$('div.new_task').dialog('close');
						$('<div>'+response.responseText+'</div>').dialog({
							title: 'An error occurred creating the Task',
							autoOpen: true
						});
						$('select#task_category_id').val('');
						$('form#new_task textarea#task_description').val('');
						$('form#new_task #task_percentcomplete').val('');
						},
				dataType: 'html'});
			return false;
		});
		
		
		// Insert code to ajaxy edit tasks
		$('div.edit_task form div.actions input[type="submit"]').live('click', function(event){
			var category_id = $('select#edit_task_category_id').val();
			var task_id = $('div.edit_task').attr("task_id");
			var surl = "/tasks/" + task_id;
			$.ajax({
				url: surl,
				type: 'post',
				data: $('div.edit_task form').serialize(),
				success: 
					function(response, status, xhr) {
						// Close Edit dialog
						$('div.edit_task').dialog('close');
						// Blank out dialog
						$('select#edit_task_category_id').val('');
						$('textarea#edit_task_description').val('');
						// Update Task element on the screen:
						// First, find current element on screen
						var currentTask = "table#task_" + task_id;
						//$(currentTask)
						
						// Next, Determine if category changed
						if (category_id != $(currentTask).parent().parent().attr("category_id"))
						{
							// If category changed, remove old element
							$(currentTask).remove();
							// and insert new element to new category
							$('div.whiteboard > div').filter(function() { if ($('#category_id', this).html() == category_id) return true; else return false;}).find('div.tasks').append(response);
						}
						else
						{
							// Else, just update the object
							$(currentTask).replaceWith(response);
						}
						$('.taskrecord').draggable({
							cursor: 'move',
							helper: 'clone'
						});
						}, 
				error:
					function(response, status, xhr) {
						$('div.edit_task').dialog('close');
						$('<div>'+response.responseText+'</div>').dialog({
							title: 'An error occurred saving the Task',
							autoOpen: true
						});
						$('select#edit_task_category_id').val('');
						$('textarea#edit_task_description').val('');
						$('form#new_task #edit_task_percentcomplete').val('');
						},
				dataType: 'html'});
			return false;
		});
		
		
		// Handle Delete button click
		$('button.deletebutton').live('click', function(event) {
			var answer = confirm("Are you sure you want to delete this task?");
			
			if (answer) {
				var task_id = $(this).attr("task_id");
				var requestString = "authenticity_token=" + $('div#authtoken').html();
				var surl = "/tasks/destroy/" + task_id;
				$.ajax({
					url: surl,
					type: 'post',
					// Need to pass authentication token
					data: requestString,
					success: function(response, status, xhr){
						var currentTask = "table#task_" + task_id;
						$(currentTask).remove();
						$('span#activeTasks').html(parseInt($('span#activeTasks').html()) - 1);
						$('span#countTotals').html(parseInt($('span#countTotals').html()) - 1);
					},
					failure: function(response, status, xhr){
						alert(response);
					},
					dataType: 'text'
				});
			}
		});
		
		// Handle Complete button click
		$('button.completebutton').live('click', function(event) {
			var answer = confirm("Are you sure you want to complete this task?");
			
			if (answer) {
				var task_id = $(this).attr("task_id");
				var requestString = "authenticity_token=" + $('div#authtoken').html();
				var surl = "/tasks/complete/" + task_id;
				$.ajax({
					url: surl,
					type: 'post',
					data: requestString,
					success: function(response, status, xhr){
						var currentTask = "table#task_" + task_id;
						$(currentTask).remove();
						$('span#activeTasks').html(parseInt($('span#activeTasks').html()) - 1);
					},
					failure: function(response, status, xhr){
						alert(response);
					},
					dataType: 'text'
				});
			}
		});
		
		$('#task_percentcomplete, #edit_task_percentcomplete, #goal_percentcomplete, #edit_goal_percentcomplete'
		).live('keydown', function(event) {
			if ((event.which >= 48 && event.which <= 57) || // Numbers
				(event.which >= 37 && event.which <= 40) || // Arrow keys
				(event.which == 8 || event.which == 46)) // Backspace & Delete
			{
				return true;
			}
			else
			{
				return false;
			}
		}).live('change', function(event) {
			if(parseInt($(this).val()) > 100)
			{
				$(this).val(100);
			}
		});

		/*** AJAX Handlers for Goals ***/
		// Insert code to ajaxy create goals
		$('form#new_goal div.actions input#goal_submit').live('click', function(event){
			var goaltype_id = $('select#goal_goaltype_id').val();
			$.ajax({
				url: '/goals',
				type: 'post',
				data: $('form#new_goal').serialize(),
				success: 
					function(response, status, xhr) {
						// Close Edit dialog
						$('div.new_goal').dialog('close');
						// Add New Task to screen
						// the response contains the html, we need to append it to the 
						// selected category.
						$('div.whiteboard > div').filter(function() { if ($(this).attr("goaltype_id") == goaltype_id) return true; else return false;}).find('div.goals').append(response);
						//Update Counts at top of page
						$('span#countTotals').html(parseInt($('span#countTotals').html()) + 1);
						$('form#new_goal textarea#goal_description').val('');
						$('form#new_goal #goal_percentcomplete').val('');
						}, 
				error:
					function(response, status, xhr) {
						$('div.new_goal').dialog('close');
						$('<div>'+response.responseText+'</div>').dialog({
							title: 'An error occurred creating the Task',
							autoOpen: true
						});
						$('form#new_goal textarea#goal_description').val('');
						$('form#new_goal #goal_percentcomplete').val('');
						},
				dataType: 'html'});
			return false;
		});
		
		
		// Insert code to ajaxy edit goals
		$('div.edit_goal form div.actions input[type="submit"]').live('click', function(event){
			var goal_id = $('div.edit_goal').attr("goal_id");
			var surl = "/goals/" + goal_id;
			$.ajax({
				url: surl,
				type: 'post',
				data: $('div.edit_goal form').serialize(),
				success: 
					function(response, status, xhr) {
						// Close Edit dialog
						$('div.edit_goal').dialog('close');
						// Blank out dialog
						$('textarea#edit_goal_description').val('');
						// Update Task element on the screen:
						// First, find current element on screen
						var currentGoal = "table#goal_" + goal_id;
						
						// Just update the object
						$(currentGoal).replaceWith(response);
					}, 
				error:
					function(response, status, xhr) {
						$('div.edit_goal').dialog('close');
						$('<div>'+response.responseText+'</div>').dialog({
							title: 'An error occurred saving the Goal',
							autoOpen: true
						});
						$('textarea#edit_goal_description').val('');
						$('form#new_goal #edit_goal_percentcomplete').val('');
					},
				dataType: 'html'});
			return false;
		});
		
		$('button.goaldeletebutton').live('click', function(event) {
			var answer = confirm("Are you sure you want to delete this goal?");
			
			if (answer) {
				var goal_id = $(this).attr("goal_id");
				var requestString = "authenticity_token=" + $('div#authtoken').html();
				var surl = "/goals/destroy/" + goal_id;
				$.ajax({
					url: surl,
					type: 'post',
					// Need to pass authentication token
					data: requestString,
					success: function(response, status, xhr){
						var currentGoal = "table#goal_" + goal_id;
						$(currentGoal).remove();
						$('span#countTotals').html(parseInt($('span#countTotals').html()) - 1);
					},
					failure: function(response, status, xhr){
						alert(response);
					},
					dataType: 'text'
				});
			}
		});
		
		// Handle Complete button click
		$('button.goalcompletebutton').live('click', function(event) {
			var answer = confirm("Are you sure you want to complete this goal?");
			
			if (answer) {
				var goal_id = $(this).attr("goal_id");
				var requestString = "authenticity_token=" + $('div#authtoken').html();
				var surl = "/goals/complete/" + goal_id;
				$.ajax({
					url: surl,
					type: 'post',
					data: requestString,
					success: function(response, status, xhr){
						var currentGoal = "table#goal_" + goal_id;
						$(currentGoal).remove();
					},
					failure: function(response, status, xhr){
						alert(response);
					},
					dataType: 'text'
				});
			}
		});
		
		$('.container').droppable({
			  accept: '.taskrecord', 
        		drop: function(event, ui) {
					var task_id = $(ui.draggable).find('button.deletebutton').attr("task_id");
					var onclick = $('#btnedittask', ui.draggable).attr("onclick");
					var ondblclick = $('.taskdata', ui.draggable).attr("ondblclick");
					var scategory_label = $('#category_label', this).html();
					
					var surl = "/tasks/update/" + task_id;
					var scategory_id = $('#category_id', this).html();
					var sauthenticity_token = $("input[name*='authenticity_token']", ui.draggable).attr("value") 
					var container = this;
					if (scategory_label == "Delivered")
					{
						$('.deletecontainer', ui.draggable).css('display', 'none');
						$('.completecontainer', ui.draggable).css('display', '');
					}
					else
					{
						$('.deletecontainer', ui.draggable).css('display', '');
						$('.completecontainer', ui.draggable).css('display', 'none');
					}
		
					$.ajax({
						type: 'POST',
						url: surl,
						data: { commit: "Edit Task",
								authenticity_token: sauthenticity_token, 
								edit_task: {category_id: scategory_id}},
        				success: function(xml) {
							var currentObject = $(ui.draggable).outerHTML();
							$(ui.draggable).remove();
							$(container).children('div.tasks').append(currentObject);
							$('.taskrecord').draggable({
								cursor: 'move',
								helper: 'clone'
							});
        				},
        				error: function(xml, status, error) {
							alert("readyState: "+xml.readyState+"\nstatus: "+xml.status);
    alert("responseText: "+xml.responseText);

							alert("Category can't exceed size limit.")
        				}
					});
				}
		});
	});	

	$(window).resize(function() {
		if ($(window).width() <= 1024)
		{
			//$('.whiteboard').css('background', 'url(\'/images/Whiteboard_small.png\') no-repeat');
			$('.container').css('width', '174px');
			$('.taskrecord').css('width', '150px');
			$('.goalcontainer').css('width', '300px');
			$('.goalrecord').css('width', '270px');
		}
		else
		{
			//$('.whiteboard').css('background', 'url(\'/images/Whiteboard.png\') no-repeat');
			$('.container').css('width', '191px');
			$('.taskrecord').css('width', '165px');
			$('.goalcontainer').css('width', '327px');
			$('.goalrecord').css('width', '298px');
		}
		
	});
	
	// Will require refactoring to standardize.
	function show_edit_task(task, taskid, description)
	{
		var percent = "";
		var container = $(task).parents('.container');
		var categoryid = $('#category_id', container).html();
		// Set Drop Down menu
		var optiontag = '#selectoptions option[value=' + categoryid + ']';
		$(optiontag).attr('selected', 'selected');
		$('div.edit_task').attr('task_id', taskid);
		
		var percent_selector = "#task_" + taskid + " div.percentcomplete";
		
		percent = $(percent_selector).html();
		
		// Set Text Area
		$('#edit_task_description').val(description);
		$('#edit_task_percentcomplete').val(percent);
		
		// Set form submit info
		$('div.edit_task form').attr('action', '/tasks/' + taskid);
		
		$('div.edit_task').dialog('open');
		$('div.edit_task #edit_task_description').focus();
	}
	
	function ShowHelp(task)
	{
		var shtml = $(task).attr('alt');
		var $dialog = $('<div></div>').html(shtml)
			.dialog({
				autoOpen: false,
				title: "Help"
		});
		$dialog.dialog('open');
	}
	
	function show_edit_goal(goalid, description)
	{
		var percent = "";
		
		var percent_selector = "#goal_" + goalid + " div.percentcomplete";
		percent = $(percent_selector).html();
		
		// Set Text Area
		$('#edit_goal_description').val(description);
		$('#edit_goal_percentcomplete').val(percent);
		
		// Set form submit info
		$('div.edit_goal form').attr('action', '/goals/' + goalid);
		$('div.edit_goal').attr('goal_id', goalid);
		
		$('div.edit_goal').dialog('open');
	}
	
	$('div.goaldata, div.taskdata').live('dblclick', function(event) {
		
		if ($(this).attr('expanded') != 'true') {
			$(this).attr('expanded', 'true');
			var oldHTML = $(this).html();
			$(this).attr('oldHTML', oldHTML);
			$(this).attr('oldHeight', $(this).height());
			var newHTML = oldHTML.replace(/\n/g, "<br>");
			$(this).html(newHTML);
			/*var lines = 1;
			if (oldHTML.match(/\n/g))
			{
				lines = lines + oldHTML.match(/\n/g).length;	
			}*/
			$(this).css('height', 'auto');
		}
		else
		{
			$(this).attr('expanded', 'false');
			var oldHTML = $(this).attr('oldHTML');
			$(this).html(oldHTML);
			$(this).animate({
				height: $(this).attr('oldHeight')
			}, 'fast');
			
		}
	});
	
	function TurnOff(objElement)
	{
		objElement.nextSibling.nextSibling.style.display = '';
		objElement.style.display = 'none';
	}
			
	function TurnOn(objElement)
	{
		objElement.previousSibling.previousSibling.style.display = '';
		objElement.style.display = 'none';
	}
