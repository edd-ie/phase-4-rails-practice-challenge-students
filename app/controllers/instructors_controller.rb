class InstructorsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with:  :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response

    def index
        instructors = Instructor.all
        render json: instructors, except: [:created_at, :updated_at], status: :ok
    end

    def show
        instructor = finder
        render json: instructor, except: [:created_at, :updated_at], include: :students ,status: :ok
    end

    def create
        new_instructor = Instructor.create!(valid_params)
        render json: new_instructor, except: [:created_at, :updated_at], status: :created
    end

    def update
        instructor = finder
        instructor.update!(valid_params)
        render json: instructor, except: [:created_at, :updated_at], status: :accepted
    end

    def destroy
        instructor = finder
        instructor.destroy
        head :no_content
    end


    
    private
        def finder
            Instructor.find(params[:id])
        end

        def valid_params
            params.permit(:id, :name)
        end

        def not_found
            render json: {error: "record not found"}, status: :not_found
        end

        def unprocessable_entity_response(invalid)
            render json: {error: invalid.record.errors.full_messages}, status: :unprocessable_entity
        end

end
