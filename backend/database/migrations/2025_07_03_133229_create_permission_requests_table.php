<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('permission_requests', function (Blueprint $table) {
            $table->date('date_leave')->nullable()->after('reason');
            $table->boolean('leave_morning')->default(false)->after('date_leave');
            $table->boolean('leave_afternoon')->default(false)->after('leave_morning');
            $table->date('date_back')->nullable()->after('leave_afternoon');
            $table->boolean('back_morning')->default(false)->after('date_back');
            $table->boolean('back_afternoon')->default(false)->after('back_morning');
        });
    }

    public function down(): void
    {
        Schema::table('permission_requests', function (Blueprint $table) {
            $table->dropColumn(['date_leave', 'leave_morning', 'leave_afternoon', 'date_back', 'back_morning', 'back_afternoon']);
        });
    }
};
