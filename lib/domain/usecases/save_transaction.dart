package payment_app.domain.usecases;

import 'package:dartz/dartz.dart';
import 'package:payment_app/core/error/failures.dart';
import 'package:payment_app/core/network/network_info.dart';
import 'package:payment_app/domain/entities/transaction.dart';
import 'package:payment_app/domain/repositories/transaction_repository.dart';

class SaveTransaction {
  final TransactionRepository repository;
  final NetworkInfo networkInfo;
  
  SaveTransaction(this.repository, this.networkInfo);
  
  Future<Either<Failure, Transaction>> call(Transaction transaction) async {
    return execute(transaction);
  }
  
  Future<Either<Failure, Transaction>> execute(Transaction transaction) async {
    final isConnected = await networkInfo.isConnected;
    
    if (isConnected) {
      return await repository.saveTransaction(transaction);
    } else {
      return await repository.saveTransaction(transaction);
    }
  }
}