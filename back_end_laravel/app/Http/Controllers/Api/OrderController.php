<?php

namespace App\Http\Controllers\Api;

use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class OrderController extends Controller
{
    public function store(Request $request)
    {
        // Validasi data order
        $request->validate([
            'transaction_time' => 'required|date',
            'total_price' => 'required|integer|min:0',
            'total_item' => 'required|integer|min:1',
            'payment_amount' => 'required|integer|min:0',
            'payment_method' => 'required|string|in:Tunai,Kartu Kredit,Debit,E-wallet',
            'cashier_id' => 'required|exists:users,id',
            'cashier_name' => 'required|string|max:255',
            'orders_items' => 'required|array|min:1',
            'orders_items.*.product_id' => 'required|exists:products,id',
            'orders_items.*.quantity' => 'required|integer|min:1',
            'orders_items.*.total_price' => 'required|integer|min:0',
        ]);

        // 1. Buat Order TANPA menyertakan 'orders_items'
        $order = Order::create([
            'transaction_time' => $request->transaction_time,
            'total_price' => $request->total_price,
            'total_item' => $request->total_item,
            'payment_amount' => $request->payment_amount,
            'payment_method' => $request->payment_method,
            'cashier_id' => $request->cashier_id,
            'cashier_name' => $request->cashier_name,
            // TIDAK ADA 'orders_items' di sini!
        ]);

        // 2. Simpan Order Items ke tabel terpisah
        $orderItemsData = [];
        foreach ($request->orders_items as $item) {
            $orderItemsData[] = [
                'order_id' => $order->id,
                'product_id' => $item['product_id'],
                'quantity' => $item['quantity'],
                'total_price' => $item['total_price'],
                'created_at' => now(),
                'updated_at' => now(),
            ];
        }
        
        // Insert batch untuk efisiensi
        OrderItem::insert($orderItemsData);

        // 3. Load relasi orderItems untuk response
        $order->load('orderItems');

        return response()->json([
            'status' => 'success',
            'message' => 'Order berhasil dibuat',
            'data' => $order
        ], 201);
    }

    public function show(string $id)
    {
        $order = Order::with('orderItems')->find($id);
        
        if (!$order) {
            return response()->json([
                'status' => 'error',
                'message' => 'Order tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'data' => $order
        ]);
    }

    public function update(Request $request, string $id)
    {
        $order = Order::find($id);
        
        if (!$order) {
            return response()->json([
                'status' => 'error',
                'message' => 'Order tidak ditemukan'
            ], 404);
        }

        $request->validate([
            'transaction_time' => 'sometimes|date',
            'total_price' => 'sometimes|integer|min:0',
            'total_item' => 'sometimes|integer|min:1',
            'payment_amount' => 'sometimes|integer|min:0',
            'payment_method' => 'sometimes|string',
            'cashier_id' => 'sometimes|exists:users,id',
            'cashier_name' => 'sometimes|string|max:255',
        ]);

        $order->update($request->only([
            'transaction_time',
            'total_price',
            'total_item',
            'payment_amount',
            'payment_method',
            'cashier_id',
            'cashier_name',
        ]));

        return response()->json([
            'status' => 'success',
            'message' => 'Order berhasil diperbarui',
            'data' => $order
        ]);
    }

    public function destroy(string $id)
    {
        $order = Order::find($id);
        
        if (!$order) {
            return response()->json([
                'status' => 'error',
                'message' => 'Order tidak ditemukan'
            ], 404);
        }

        // Hapus order (order items akan terhapus otomatis karena cascade)
        $order->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Order berhasil dihapus'
        ]);
    }
}