<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class OrderItem extends Model
{
    use HasFactory;
    
    protected $guarded = ['id'];
    
    // PERBAIKAN: nama tabel sesuai migration
    protected $table = 'orders_items';
    
    protected $fillable = [
        'order_id',
        'product_id',
        'quantity',
        'total_price', // PERBAIKAN: sesuai nama kolom di migration
    ];

    /**
     * Relasi ke Order
     */
    public function order()
    {
        return $this->belongsTo(Order::class);
    }
    
    /**
     * Optional: Relasi ke Product jika ada model Product
     */
    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}