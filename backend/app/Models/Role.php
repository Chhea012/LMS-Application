<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

class Role extends Model
{
    use HasFactory;
    // app/Models/Role.php
    protected $fillable = ['role_name', 'level', 'description'];


    public function users()
    {
        return $this->hasMany(User::class);
    }

    public function accessControls()
    {
        return $this->hasMany(AccessControl::class);
    }
    // Format created_at
    public function getCreatedAtAttribute($value)
    {
        return Carbon::parse($value)->format('F d, Y');
    }

    // Format updated_at
    public function getUpdatedAtAttribute($value)
    {
        return Carbon::parse($value)->format('F d, Y');
    }
}
