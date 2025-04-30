<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;

class RegisterUserRequest extends BaseFormRequest
{
     /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array|string>
     */
    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:users',
            'password' => 'required|min:6|alpha_num:ascii',
        ];
    }
}
