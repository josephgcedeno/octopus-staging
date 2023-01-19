import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/quote/quote_response.dart';
import 'package:octopus/infrastructures/repository/quote_repository.dart';
import 'package:octopus/module/time_in/service/cubit/quote_cubit.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  late MockQuoteRepository mockQuoteRepository;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
  });
  group('Quote cubit.', () {
    blocTest<QuoteCubit, QuoteState>(
      'On successful fetch quote, it should emit FetchQuoteSuccess.',
      build: () {
        when(() => mockQuoteRepository.fetchQuote()).thenAnswer((_) async {
          return QuoteResponse(author: '', content: '', id: '');
        });

        return QuoteCubit(quoteRepository: mockQuoteRepository);
      },
      act: (QuoteCubit cubit) => cubit.fetchQuote(),
      expect: () => <TypeMatcher<QuoteState>>[
        isA<FetchQuoteLoading>(),
        isA<FetchQuoteSuccess>(),
      ],
    );

    blocTest<QuoteCubit, QuoteState>(
      'On failed fetch quote, it should emit FetchQuoteFailed.',
      build: () {
        when(() => mockQuoteRepository.fetchQuote()).thenThrow(
          APIResponse<QuoteResponse>(
            message: '',
            success: false,
            errorCode: '',
            data: QuoteResponse(author: '', content: '', id: ''),
          ),
        );

        return QuoteCubit(quoteRepository: mockQuoteRepository);
      },
      act: (QuoteCubit cubit) => cubit.fetchQuote(),
      expect: () => <TypeMatcher<QuoteState>>[
        isA<FetchQuoteLoading>(),
        isA<FetchQuoteFailed>(),
      ],
    );
  });
}
