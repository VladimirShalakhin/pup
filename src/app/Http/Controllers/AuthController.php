<?php

namespace App\Http\Controllers;

use App\Http\Requests\RegisterUserRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;

class AuthController extends Controller
{
    public function register(RegisterUserRequest $request): JsonResponse
    {
        $user = User::create([
            'name' => $request->safe()->input('name'),
            'email' => $request->safe()->input('email'),
            'password' => $request->safe()->input('password'),
        ]);
        return response()->json([
            'name' => $user->name,
            'email' => $user->email,
        ]);
    }
}
