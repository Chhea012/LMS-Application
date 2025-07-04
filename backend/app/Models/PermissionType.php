<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

class PermissionType extends Model
{
    use HasFactory;
    protected $fillable = ['name', 'description'];

     public function permissionAccess()
    {
        return $this->hasMany(PermissionAccess::class);
    }

    public function permissionRequests()
    {
        return $this->hasMany(PermissionRequest::class);
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
