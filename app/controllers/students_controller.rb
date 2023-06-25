class StudentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with:  :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response

    def index
        students = Student.all
        render json: students, except: [:created_at, :updated_at], status: :ok
    end

    def show
        student = finder
        render json: student, except: [:created_at, :updated_at], include: :instructor ,status: :ok
    end

    def create
        new_Student = Student.create!(valid_params)
        render json: new_Student, except: [:created_at, :updated_at], status: :created
    end

    def update
        student = finder
        student.update!(valid_params)
        render json: student, except: [:created_at, :updated_at], status: :accepted
    end

    def destroy
        student = finder
        student.destroy
        head :no_content
    end

    private
        def finder
            Student.find(params[:id])
        end

        def valid_params
            params.permit(:id, :name, :instructor_id, :age, :major)
        end

        def not_found
            render json: {error: "record not found"}, status: :not_found
        end

        def unprocessable_entity_response(invalid)
            render json: {error: invalid.record.errors.full_messages}, status: :unprocessable_entity
        end
end
