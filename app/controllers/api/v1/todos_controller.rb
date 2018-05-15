class Api::V1::TodosController < Api::V1::BaseController

	before_action :login_required
	before_action :set_todo, only: [:show, :edit, :update, :destroy]

	# GET /admin/v1/todos
	def index
		limit = params[:limit].to_i == -1 ? 100 : params[:limit]

		sort_by = params[:sort_by]

		sort_direction = params[:sort_direction]

		@todos_total = Todo.where(user_id: @current_user).order("#{sort_by} #{sort_direction}")

		@todos = @todos_total.paginate(:page => params[:page], :per_page => limit).offset(params[:offset])

		render_data({total: @todos_total.count, result_total: @todos.count, todos: @todos.as_api_response(:todo_list)},'todos list..!!!') if @todos
	end

	def create
    @todo = Todo.new(todo_params)
      if @todo.save
				@todo.update(user_id: @current_user)
				render_data({ todo: @todo.as_api_response(:todo_list) }, 'Create successfully..!!!' )
      else
				 error_data( 'Errors while create new todo...!!!!' )
      end
  end

	# DELETE
	def destroy
		render_data({ todo: {} }, 'todo deleted...!!!') if @todo.destroy!
	end

	# GET
	def show
		render_data({ todos: @todo.as_api_response(:todo_list) }, 'Todo detail..!!!!')
	end


	# PATCH/PUT /todos/1
	# PATCH/PUT /todos/1.json
	def update
		if @todo.update(todo_params)
			render_data({ todos: @todo.as_api_response(:todo_list) }, "Todo was successfully updated.")
		else
			error_data( 'Errors while create new todo...!!!!' )
		end
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_todo
		@todo = Todo.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def todo_params
		params.permit(:data, :due_date, :priority, :user)
	end

end
