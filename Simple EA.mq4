#property copyright "Andrew Young"

/*

	Testing this shit and how sweet i can fork you!

*/



// External variables
extern double LotSize = 0.1;
extern double StopLoss = 50;
extern double TakeProfit = 100;
extern int Slippage = 5;
extern int MagicNumber = 123;
extern int FastMAPeriod = 10;
extern int SlowMAPeriod = 20;

// Global variables
int BuyTicket;
int SellTicket;
double UsePoint;
int UseSlippage;

// Init function
int init()
	{
		UsePoint = PipPoint(Symbol());
		UseSlippage = GetSlippage(Symbol(),Slippage);
	}
	
// Start function
int start()
{

		// Moving averages
		double FastMA = iMA(NULL,0,FastMAPeriod,0,0,0,0);
		double SlowMA = iMA(NULL,0,SlowMAPeriod,0,0,0,0);
	
	

// Buy order 
if(FastMA > SlowMA && BuyTicket == 0)

	{
			OrderSelect(SellTicket,SELECT_BY_TICKET);

			// Close order
			if(OrderCloseTime() == 0 && SellTicket > 0)
		{
			double CloseLots = OrderLots();
			double ClosePrice = Ask;
			bool Closed = OrderClose(SellTicket,CloseLots,ClosePrice,UseSlippage,Red);
		}	

		double OpenPrice = Ask;
		// Calculate stop loss and take profit
		if(StopLoss > 0) double BuyStopLoss = OpenPrice - (StopLoss * UsePoint);
		if(TakeProfit > 0) double BuyTakeProfit = OpenPrice + (TakeProfit * UsePoint);

		// Open buy order
		BuyTicket = OrderSend(Symbol(),OP_BUY,LotSize,OpenPrice,UseSlippage,
			BuyStopLoss,BuyTakeProfit,"Buy Order",MagicNumber,0,Green);
		
		SellTicket = 0;
	}

// Sell Order 
if(FastMA < SlowMA && SellTicket == 0)
	{
		OrderSelect(BuyTicket,SELECT_BY_TICKET);
		if(OrderCloseTime() == 0 && BuyTicket > 0)
		{

			CloseLots = OrderLots();
			ClosePrice = Bid;
			Closed = OrderClose(BuyTicket,CloseLots,ClosePrice,UseSlippage,Red);
		
		}
	
	OpenPrice = Bid;
	if(StopLoss > 0) double SellStopLoss = OpenPrice + (StopLoss * UsePoint);
	if(TakeProfit > 0) double SellTakeProfit = OpenPrice - (TakeProfit * UsePoint);
	
	SellTicket = OrderSend(Symbol(),OP_SELL,LotSize,OpenPrice,UseSlippage,
	SellStopLoss,SellTakeProfit,"Sell Order",MagicNumber,0,Red);


		BuyTicket = 0;
	}
	
	return(0);
}
